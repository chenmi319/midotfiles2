#!/usr/bin/env bash
# 从 init.vim 读取 treesitter parser 列表，通过 gcc 手动编译安装。
# 用途：远程 Linux 服务器上 nvim-treesitter 的 :TSInstall 无法正常工作时使用。
# 依赖：git, gcc
#
# nvim-treesitter (main branch) 安装目录结构：
#   ~/.local/share/nvim/site/parser/{lang}.so      — 编译后的 parser
#   ~/.local/share/nvim/site/queries/{lang}/        — 软链到插件 runtime/queries/{lang}
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INIT_VIM="${SCRIPT_DIR}/../nvim/init.vim"
PLUGIN_DIR="${HOME}/.local/share/nvim/plugged/nvim-treesitter"
SITE_DIR="${HOME}/.local/share/nvim/site"
PARSER_DIR="${SITE_DIR}/parser"
QUERY_DIR="${SITE_DIR}/queries"
TMPDIR="${TMPDIR:-/tmp}/ts-parsers-$$"

# 从 init.vim 提取 parser 列表
extract_parsers() {
  grep "require('nvim-treesitter').install(" "$INIT_VIM" \
    | grep -oP "'[a-z_]+'" \
    | tr -d "'"
}

# 语言 → GitHub org/repo[:subdir] 映射
# 大多数在 tree-sitter 组织下，少数例外单独指定
declare -A REPO_MAP=(
  [vimdoc]="neovim/tree-sitter-vimdoc"
  [gitcommit]="gbprod/tree-sitter-gitcommit"
  [markdown]="tree-sitter-grammars/tree-sitter-markdown:tree-sitter-markdown"
  [markdown_inline]="tree-sitter-grammars/tree-sitter-markdown:tree-sitter-markdown-inline"
  [typescript]="tree-sitter/tree-sitter-typescript:typescript"
  [tsx]="tree-sitter/tree-sitter-typescript:tsx"
)

# 已知只有 parser.c（无 scanner）的语言
declare -A NO_SCANNER=(
  [json]=1
  [vimdoc]=1
  [diff]=1
  [gitcommit]=1
)

resolve_repo() {
  local lang=$1
  if [[ -n "${REPO_MAP[$lang]:-}" ]]; then
    echo "${REPO_MAP[$lang]}"
  else
    echo "tree-sitter/tree-sitter-${lang}"
  fi
}

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

mkdir -p "$PARSER_DIR" "$QUERY_DIR" "$TMPDIR"

PARSERS=$(extract_parsers)
if [[ -z "$PARSERS" ]]; then
  echo "ERROR: 无法从 $INIT_VIM 提取 parser 列表" >&2
  exit 1
fi

echo "Parser 列表: $PARSERS"
echo "安装目录: $PARSER_DIR"
echo ""

FAILED=()
SKIPPED=()
INSTALLED=()

for lang in $PARSERS; do
  # 已存在则跳过（加 -f/--force 强制重装）
  if [[ -f "$PARSER_DIR/${lang}.so" ]] && [[ "${1:-}" != "-f" && "${1:-}" != "--force" ]]; then
    SKIPPED+=("$lang")
    continue
  fi

  spec=$(resolve_repo "$lang")
  org_repo="${spec%%:*}"
  subdir="${spec#*:}"
  [[ "$subdir" == "$spec" ]] && subdir=""

  repo_name="${org_repo#*/}"
  clone_dir="$TMPDIR/$repo_name"

  echo "=== $lang ==="

  # clone（同一 repo 只 clone 一次）
  if [[ ! -d "$clone_dir" ]]; then
    if ! git clone --depth=1 "https://github.com/${org_repo}.git" "$clone_dir" 2>&1; then
      echo "  FAILED: git clone 失败"
      FAILED+=("$lang")
      continue
    fi
  fi

  build_dir="$clone_dir"
  [[ -n "$subdir" ]] && build_dir="$clone_dir/$subdir"

  # 确定源文件
  src_files=("$build_dir/src/parser.c")
  if [[ -z "${NO_SCANNER[$lang]:-}" ]] && [[ -f "$build_dir/src/scanner.c" ]]; then
    src_files+=("$build_dir/src/scanner.c")
  fi

  # 编译 parser
  if gcc -o "$PARSER_DIR/${lang}.so" -shared -fPIC -O2 -I "$build_dir/src" "${src_files[@]}" 2>&1; then
    echo "  parser OK"
    INSTALLED+=("$lang")
  else
    echo "  FAILED: gcc 编译失败"
    FAILED+=("$lang")
    continue
  fi

  # 创建 queries 软链（指向插件 runtime/queries/{lang}）
  query_src="${PLUGIN_DIR}/runtime/queries/${lang}"
  query_dst="${QUERY_DIR}/${lang}"
  if [[ -d "$query_src" ]] && [[ ! -e "$query_dst" ]]; then
    ln -s "$query_src" "$query_dst"
    echo "  queries linked"
  elif [[ -L "$query_dst" ]]; then
    echo "  queries already linked"
  fi
done

echo ""
echo "--- 结果 ---"
[[ ${#INSTALLED[@]} -gt 0 ]] && echo "已安装: ${INSTALLED[*]}"
[[ ${#SKIPPED[@]} -gt 0 ]]   && echo "已跳过（已存在，-f 强制重装）: ${SKIPPED[*]}"
[[ ${#FAILED[@]} -gt 0 ]]    && echo "失败: ${FAILED[*]}" && exit 1
echo "完成。"
