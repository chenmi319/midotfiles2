#!/bin/zsh -f
# 只加载环境选择函数和 hook，避免完整 zshrc 的初始化、凭证读取及网络副作用。
setopt ERR_EXIT PIPE_FAIL
repo=${0:A:h:h}
work=$(mktemp -d)
work=${work:A}
trap 'rm -rf -- "$work"' EXIT
export HOME="$work/home"
unset VIRTUAL_ENV CONDA_PREFIX _UV_AUTO_VENV
mkdir -p "$HOME/scripts" "$work/project/sub/nested" "$work/other" "$work/project/broken/.venv/bin"

fail() { print -u2 -r -- "FAIL: $*"; exit 1; }
assert_env() {
  [[ "$VIRTUAL_ENV" == "$1" ]] || fail "$2: unexpected VIRTUAL_ENV"
  [[ "$path[1]" == "$1/bin" ]] || fail "$2: unexpected PATH"
}

# 模拟标准 activate 的 PATH 保存、deactivate 和 VIRTUAL_ENV 设置，不下载 Python。
make_venv() {
  mkdir -p "$1/bin"
  print -r -- '(( ${+functions[deactivate]} )) && deactivate
export VIRTUAL_ENV="${${(%):-%x}:A:h:h}"
_OLD_VIRTUAL_PATH="$PATH"
export PATH="$VIRTUAL_ENV/bin:$PATH"
(( ++activations ))
deactivate() {
  export PATH="$_OLD_VIRTUAL_PATH"
  unset VIRTUAL_ENV _OLD_VIRTUAL_PATH
  unfunction deactivate
}' > "$1/bin/activate"
}
typeset -gi activations=0
base="$HOME/.venv"
project="$work/project/.venv"
nested="$work/project/sub/nested/.venv"
manual="$work/manual env"
for venv in "$base" "$project" "$nested" "$manual"; do make_venv "$venv"; done

block=$(awk '/^_uv_select_env\(\)/ { copy=1 } copy { print } /^load-uv-venv$/ { exit }' "$repo/zshrc")
[[ -n "$block" ]] || fail 'function block not found'
autoload -Uz add-zsh-hook
builtin cd "$HOME"
alias uvsb='false'
eval "$block"
assert_env "$base" auto_startup
builtin cd "$work/project/sub"
assert_env "$project" auto_ancestor
builtin cd "$work/project/sub/nested"
assert_env "$nested" auto_nearest
builtin cd "$HOME"
assert_env "$base" auto_home
count=$activations
eval "$block"
[[ $activations == $count && ${#chpwd_functions} == 1 ]] || fail 'reload duplicated activation or hook'

# 自动环境在项目边界退出，手动环境保留并警告。
for marker in pyproject.toml uv.lock uv.toml; do
  boundary="$work/auto-$marker"
  mkdir -p "$boundary/sub"
  touch "$boundary/$marker"
  builtin cd "$boundary/sub" 2> "$work/error" || true
  [[ "$PWD" == "$boundary/sub" && -z "$VIRTUAL_ENV" && -z "$_UV_AUTO_VENV" && -s "$work/error" ]] || fail 'auto boundary did not deactivate'
  [[ "$path[1]" != "$base/bin" ]] || fail 'auto boundary retained base PATH'
  if load-uv-venv 2> "$work/error"; then fail 'boundary returned success'; fi
  builtin cd "$HOME"
  assert_env "$base" auto_resume
  source "$manual/bin/activate"
  builtin cd "$boundary/sub" 2> "$work/error" || true
  assert_env "$manual" manual_boundary
  [[ -z "$_UV_AUTO_VENV" && "$(<"$work/error")" == *仍然激活* ]] || fail 'manual boundary missing warning'
  deactivate
  builtin cd "$HOME"
done

# 显式选择同一路径也转为手动管理。
uvsb
[[ -z "$_UV_AUTO_VENV" ]] || fail 'manual selection retained auto ownership'
builtin cd "$work/project"
assert_env "$base" manual_pin
deactivate
builtin cd "$HOME"
assert_env "$base" auto_after_deactivate

# 同一 shell 中实际激活的手动环境和 Conda 不被自动覆盖。
unset _UV_AUTO_VENV
builtin cd "$work/project"
assert_env "$base" manual_active
deactivate
export CONDA_PREFIX="$work/conda"
builtin cd "$HOME"
[[ -z "$VIRTUAL_ENV" ]] || fail 'overrode conda'
builtin cd "$boundary" 2> "$work/error" || true
[[ "$(<"$work/error")" == *仍然激活* ]] || fail 'conda boundary missing warning'
unset CONDA_PREFIX
builtin cd "$HOME"
assert_env "$base" conda_exit

# 新进程只继承变量和 PATH，不继承 deactivate；模拟 tmux 恢复后的残留状态。
print -r -- "$block" > "$work/env-block.zsh"
for scenario in project home boundary metachar conda; do
  inherited="$base"
  destination="$work/project/sub"
  expected="$project"
  conda=''
  case "$scenario" in
    home) destination="$HOME"; expected="$base" ;;
    boundary) destination="$boundary/sub"; expected='' ;;
    metachar) inherited="$work/inherited [env]" ;;
    conda) conda="$work/conda"; expected="$base" ;;
  esac
  VIRTUAL_ENV="$inherited" VIRTUAL_ENV_PROMPT=stale CONDA_PREFIX="$conda" \
    PATH="/usr/local/bin:$inherited/bin:$PATH:$inherited/bin" \
    command zsh -f -s -- "$work/env-block.zsh" "$destination" "$expected" "$inherited" "$scenario" <<'ZSH'
setopt ERR_EXIT PIPE_FAIL
block_file="$1" destination="$2" expected="$3" inherited_bin="$4/bin" scenario="$5"
trap 'rc=$?; (( rc == 0 )) || print -u2 -r -- "FAIL: inherited scenario $scenario ($rc)"' EXIT
[[ ${+functions[deactivate]} == 0 ]] || exit 1
builtin cd "$destination"
autoload -Uz add-zsh-hook
if source "$block_file" 2> "$block_file.error"; then
  [[ "$scenario" != boundary ]] || exit 1
else
  [[ "$scenario" == boundary && -s "$block_file.error" ]] || exit 1
fi
[[ "$VIRTUAL_ENV" == "$expected" ]] || exit 1
if [[ "$scenario" == conda ]]; then
  [[ -z "$_UV_AUTO_VENV" && ${+functions[deactivate]} == 0 ]] || exit 1
elif [[ -n "$expected" ]]; then
  [[ "$path[1]" == "$expected/bin" && "$_UV_AUTO_VENV" == "$expected" && ${+functions[deactivate]} == 1 ]] || exit 1
  # 退出新环境后，也不应把旧环境的 PATH 恢复回来。
  deactivate
  for entry in "${path[@]}"; do [[ "$entry" != "$inherited_bin" ]] || exit 1; done
else
  [[ -z "$VIRTUAL_ENV_PROMPT" && -z "$_UV_AUTO_VENV" ]] || exit 1
  for entry in "${path[@]}"; do [[ "$entry" != "$inherited_bin" ]] || exit 1; done
fi
ZSH
done

# 自动选择损坏的环境也要退出原先自动激活的 base。
builtin cd "$work/project/broken" 2> "$work/error" || true
[[ -z "$VIRTUAL_ENV" && -s "$work/error" ]] || fail 'broken environment retained auto base'
add-zsh-hook -d chpwd load-uv-venv
builtin cd "$work/project/sub"
uvsb
assert_env "$project" ancestor
builtin cd "$work/project/sub/nested"
assert_env "$project" no_auto_switch
uvsb
assert_env "$nested" nearest
builtin cd "$work/other"
uvsb
assert_env "$base" outside_home_fallback
builtin cd "$HOME/scripts"
count=$activations
uvsb
assert_env "$base" home_ancestor
[[ $activations == $count ]] || fail 'reactivated same environment'
eval "$block"
[[ $activations == $count ]] || fail 'activated on reload'
add-zsh-hook -d chpwd load-uv-venv

ln -s "$work/project" "$work/project-link"
builtin cd "$work/project-link/sub"
uvsb
assert_env "$project" symlink
count=$activations
builtin cd "$work/project"
uvsb
[[ $activations == $count ]] || fail 'reactivated symlink target'
source "$manual/bin/activate"
uvsb
assert_env "$project" explicit_switch

# 每种标记都阻止越过当前或祖先项目边界。
for marker in pyproject.toml uv.lock uv.toml; do
  boundary="$HOME/projects/$marker"
  mkdir -p "$boundary/sub"
  touch "$boundary/$marker"
  for dir in "$boundary" "$boundary/sub"; do
    builtin cd "$dir"
    count=$activations
    if uvsb 2> "$work/error"; then fail "crossed $marker boundary"; fi
    [[ -s "$work/error" && $activations == $count ]] || fail 'missing boundary protection'
    assert_env "$project" boundary_preserves_environment
  done
  make_venv "$boundary/.venv"
  uvsb
  assert_env "$boundary/.venv" same_level_venv_wins
  builtin cd "$work/project"
  uvsb
done

# home 外也不能绕过边界回退；嵌套项目不能借用外层项目环境。
for boundary in "$work/outside" "$work/project/child"; do
  mkdir -p "$boundary/sub"
  touch "$boundary/uv.lock"
  builtin cd "$boundary/sub"
  if uvsb 2> "$work/error"; then fail 'boundary fell back to another environment'; fi
  assert_env "$project" boundary_no_fallback
done

# 无激活环境时也明确失败，不悄悄激活 base。
deactivate
if uvsb 2> "$work/error"; then fail 'boundary allowed activation'; fi
[[ -z "$VIRTUAL_ENV" ]] || fail 'activated default across boundary'
builtin cd "$work/project"
uvsb

builtin cd "$work/project/broken"
if uvsb 2> "$work/error"; then fail 'skipped broken nearest environment'; fi
[[ -s "$work/error" ]] || fail 'missing diagnostic'
assert_env "$project" missing_preserves_previous
print -r -- 'return 7' > "$work/project/broken/.venv/bin/activate"
if uvsb 2> "$work/error"; then fail 'accepted failed activation'; fi
[[ -s "$work/error" ]] || fail 'missing failure diagnostic'
print -r -- 'return 0' > "$work/project/broken/.venv/bin/activate"
if uvsb 2> "$work/error"; then fail 'accepted invalid VIRTUAL_ENV'; fi
[[ -s "$work/error" ]] || fail 'missing invalid environment diagnostic'
builtin cd "$work/other"
rm -- "$base/bin/activate"
if uvsb 2> "$work/error"; then fail 'accepted missing default'; fi
[[ -s "$work/error" ]] || fail 'missing default diagnostic'
print -r -- 'PASS: automatic/manual uv switching, boundaries, ownership, reload and failures'
