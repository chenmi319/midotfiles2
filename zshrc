### --- 1. P10k 即时提示 -----------------------------------------------------
# 必须位于文件最顶部；需要控制台输入的代码（密码提示等）放在此块之前
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### --- 2. 环境变量与 PATH ---------------------------------------------------
# PATH 去重（首次出现优先）
typeset -U path PATH

export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/opt/homebrew/opt/libpq/bin:$HOME/.opencode/bin:$BUN_INSTALL/bin:$PATH"

export LANG=en_US.UTF-8
# LC_ALL 强制覆盖所有 locale 分类，会使 LC_* 单项设置无效；
# 仅在需要确保所有分类一致时使用，否则只设 LANG 即可
export LC_ALL=en_US.UTF-8
export EDITOR=vim
export VISUAL="$EDITOR"
export LESS="-F -i -j4 -M -R -w -z-4 --mouse"

# Homebrew 镜像（清华 TUNA）
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

### --- 3. Oh-My-Zsh 配置 ---------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# 自动更新：提醒模式，每 14 天检查一次
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 14

# 补全等待时显示红点
COMPLETION_WAITING_DOTS="true"

# nvm 插件：遇到 .nvmrc 自动切换版本
zstyle ':omz:plugins:nvm' autoload yes
zstyle ':omz:plugins:nvm' silent-autoload yes

# z 插件：智能大小写、显示目标路径、列表中用 ~ 缩写、排除目录
ZSHZ_CASE=smart
ZSHZ_ECHO=1
ZSHZ_TILDE=1
ZSHZ_EXCLUDE_DIRS=($HOME /tmp /private/tmp)

plugins=(
  aliases
  colored-man-pages
  command-not-found
  encode64
  safe-paste
  tmux
  z
  git
  redis-cli
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
)

### --- 4. 补全系统 ----------------------------------------------------------
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
fpath=($HOME/.docker/completions $fpath)

# 可调参数
ZCOMP_CACHE_DIR=${ZCOMP_CACHE_DIR:-$HOME/.zcompcache}
ZCOMP_CACHE_TTL_DAYS=${ZCOMP_CACHE_TTL_DAYS:-14}
ZCOMP_CACHE_CLEAN_INTERVAL_SECS=${ZCOMP_CACHE_CLEAN_INTERVAL_SECS:-86400}

mkdir -p "$ZCOMP_CACHE_DIR"

# 自动清理（带锁 + 限频，后台执行不阻塞启动）
_zcompcache_clean() {
  local stamp="$ZCOMP_CACHE_DIR/.last_clean"
  local lock="$ZCOMP_CACHE_DIR/.clean.lock"
  local now=$EPOCHSECONDS
  local last=0

  [[ -f $stamp ]] && read -r last < "$stamp"
  [[ $last != <-> ]] && last=0
  (( now - last < ZCOMP_CACHE_CLEAN_INTERVAL_SECS )) && return 0

  # 清除残留锁文件（超过 60 分钟视为异常）
  command find "$lock" -mmin +60 -delete 2>/dev/null

  if ( set -o noclobber; : > "$lock" ) 2>/dev/null; then
    trap 'rm -f "$lock"' EXIT
    command find "$ZCOMP_CACHE_DIR" \
      -type f ! -name '.last_clean' ! -name '.clean.lock' \
      -mtime +$((ZCOMP_CACHE_TTL_DAYS)) -print -delete >/dev/null 2>&1
    command find "$ZCOMP_CACHE_DIR" -type d -empty -delete >/dev/null 2>&1
    print -r -- "$now" >| "$stamp"
  fi
}
_zcompcache_clean &!

# 手动一键清理
zcompcache-clear() {
  command find "$ZCOMP_CACHE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null
  : >| "$ZCOMP_CACHE_DIR/.last_clean"
  echo "zcompcache cleared."
}

### --- 5. 加载 Oh-My-Zsh ---------------------------------------------------
source $ZSH/oh-my-zsh.sh

### --- 6. Zsh 选项与历史记录 ------------------------------------------------
# 放在 source oh-my-zsh.sh 之后，覆盖 OMZ 默认的 share_history 等设置
HISTSIZE=200000
SAVEHIST=200000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY INC_APPEND_HISTORY_TIME EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY
setopt HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST
# 关闭 OMZ 的 share_history（与 INC_APPEND_HISTORY_TIME 互斥）
unsetopt SHARE_HISTORY

unsetopt auto_name_dirs

# 覆盖 OMZ lib/completion.zsh 的默认值
# Ctrl+W 分词：去掉下划线，使其与连字符一样作为分隔符（OMZ 会重置为空）
WORDCHARS='*?[]~=&;!#$%^(){}<>'
# 补全缓存统一到 ~/.zcompcache（OMZ 默认指向 ~/.oh-my-zsh/cache）
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

### --- 7. 工具初始化 --------------------------------------------------------
# mamba / micromamba（此块由 mamba init 管理）
export MAMBA_EXE="$HOME/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"
fi
unset __mamba_setup

# goenv
command -v goenv >/dev/null 2>&1 && eval "$(goenv init -)"

# uv / cargo 环境
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# bun 补全
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# kubectl 补全（缓存；kubectl 更新时自动重新生成）
if (( $+commands[kubectl] )); then
  _kubectl_comp="${XDG_CACHE_HOME:-$HOME/.cache}/kubectl_completion.zsh"
  if [[ ! -f "$_kubectl_comp" || "$commands[kubectl]" -nt "$_kubectl_comp" ]]; then
    mkdir -p "${_kubectl_comp:h}" 2>/dev/null
    _kubectl_tmp="$_kubectl_comp.tmp.$$"
    if kubectl completion zsh >| "$_kubectl_tmp" 2>/dev/null && [[ -s "$_kubectl_tmp" ]]; then
      mv -f "$_kubectl_tmp" "$_kubectl_comp"
    else
      rm -f "$_kubectl_tmp"
    fi
  fi
  [[ -f "$_kubectl_comp" ]] && source "$_kubectl_comp"
  unset _kubectl_comp _kubectl_tmp
fi

# aliyun CLI 补全
(( $+commands[aliyun] )) && complete -o nospace -F "$commands[aliyun]" aliyun

### --- 8. 函数定义 ----------------------------------------------------------
# 修复终端鼠标状态（p10k 初始化后通过 precmd 钩子运行）
fix_mouse() {
  printf '\e[?1000l\e[?1002l\e[?1006l\e[?1003l\e[?2004l' >/dev/tty
}

# tmux 中同步 SSH agent 环境变量
fixssh() {
  eval $(tmux show-env \
    |sed -n 's/^\(SSH_[^=]*\)=\(.*\)/export \1="\2"/p')
}

# Docker 运行辅助：交互环境用 -it，管道/脚本用 -i
_dockrun() {
  local tty_args=()
  if [ -t 0 ] && [ -t 1 ]; then
    tty_args=(-it)
  else
    tty_args=(-i)
  fi
  docker run --rm "${tty_args[@]}" "$@"
}

# MySQL 5.7 客户端（EOL 2023-10；仅用作客户端连接远程库）
mysql57() { _dockrun mysql:5.7 env LANG=C.UTF-8 mysql -A "$@"; }

# Postgres 客户端（不同版本）
psql13() { _dockrun postgres:13 psql "$@"; }
psql11() { _dockrun postgres:11 psql "$@"; }
psql10() { _dockrun postgres:10 psql "$@"; }

# Redis CLI（通过 Docker 运行）
redis-cli() { _dockrun redis:alpine redis-cli "$@"; }

# 符号链接辅助：已存在且正确则跳过，否则备份后创建
try_link() {
  if (( $# != 2 )); then
    echo "Usage: try_link <source> <target>" >&2
    return 1
  fi
  if [[ -L "$2" ]] && [[ "$(readlink "$2")" == "$1" ]]; then
    return 0
  fi
  if [[ -e "$2" || -L "$2" ]]; then
    mv -f "$2" "$2.bak.$(date +%Y%m%d%H%M%S)"
  fi
  ln -s "$1" "$2"
}

# 更新 dotfiles 仓库
update_mi_dot_files() {
  git -C ~/.midotfiles2 pull
}

# uv 虚拟环境自动激活/反激活（基于 .venv 目录）
autoload -U add-zsh-hook
load-uv-venv() {
  if [[ -f "$PWD/.venv/bin/activate" ]]; then
    if [[ "$VIRTUAL_ENV" != "$PWD/.venv" ]]; then
      source "$PWD/.venv/bin/activate"
    fi
  elif [[ -n "$VIRTUAL_ENV" ]] && [[ "$VIRTUAL_ENV" == */.venv ]]; then
    deactivate 2>/dev/null
  fi
}
add-zsh-hook chpwd load-uv-venv
load-uv-venv

# 代理开关
proxy()   { export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890; }
unproxy() { unset http_proxy https_proxy all_proxy; }

# OpenCode 包装（强制中文 locale）
oc()  { LANG=zh_CN.UTF-8 LC_CTYPE=zh_CN.UTF-8 opencode "$@"; }
occ() { LANG=zh_CN.UTF-8 LC_CTYPE=zh_CN.UTF-8 opencode "$@" --continue; }

### --- 9. 别名 --------------------------------------------------------------
alias conda=micromamba
alias genpass='openssl rand -base64 24 | cut -c1-16'
alias vimns='VIM_NO_SESSION=1'
alias uvs='source .venv/bin/activate'
alias uvsb="source $HOME/uv_venv/base/bin/activate"

### --- 10. Kubernetes 与 Helm -----------------------------------------------
# KUBECONFIG：自动聚合 ~/.kube 下的配置文件
typeset -gaU KUBEFILES
setopt NULL_GLOB
KUBEFILES=($HOME/.kube/chenmi-* $HOME/.kube/*eks* $HOME/.kube/*rancher*.yaml $HOME/.kube/*mixbio*.yaml $HOME/.kube/*mycluster)
unsetopt NULL_GLOB
export KUBECONFIG="${(j.:.)KUBEFILES}"

# kubectl 上下文快捷别名
alias kube_prod_ro='kubectl --kubeconfig ~/.kube/chenmi-kube-pro-dev-ro --context=prod'
alias kube_prod='kubectl --context=prod'
alias kube_prod_eks='kubectl --context=eks'
alias kube_prod_nx='kubectl --context=prod-nx'
alias kube_ali_dev='kubectl --context=ali-dev'
alias kube_ali_dev_ask='kubectl --context=ali-dev-ask'
alias kube_ali_dev_worker='kubectl --context=ali-dev-worker'
alias kube_ali_prod='kubectl --context=ali-prod'
alias kube_ali_prod_worker='kubectl --context=ali-prod-worker'
alias kube_mixbio_dev='kubectl --context=mixbio-dev'
alias kube_rancher_rke='kubectl --context=rancher-rke'
alias kube_mixbio_rancher='kubectl --context=mixbio-rancher-local'
alias kube_mixbio='kubectl --context=mixbio'
alias kube_mixbio_prod='kubectl --context=mixbio-prod'
alias kube_azure='kubectl --context=azure-dev1'
alias kube_ali_applyai='kubectl --context=ali-applyai'
# 需要在 /etc/hosts 添加 `127.0.0.1 host.docker.internal`
alias kube_mycluster='kubectl --context=k3d-mycluster'

# 命名空间创建脚本
alias create_ns_prod='python3 ./main.py prod'
alias create_ns_prod_nx='python3 ./main.py nx-prod'
alias create_ns_ali_dev='python3 ./main.py ali-dev'
alias create_ns_ali_dev_ask='python3 ./main.py ali-dev-ask'
alias create_ns_ali_dev_worker='python3 ./main.py ali-dev-worker'
alias create_ns_ali_prod='python3 ./main.py ali-prod'
alias create_ns_ali_prod_worker='python3 ./main.py ali-prod-worker'
alias create_ns_mixbio_prod='python3 ./main_n.py mixbio-prod'

# K8s 权限创建脚本
alias new-k8s-permission_prod='python3 ./main.py prod'
alias new-k8s-permission_ali_dev='python3 ./main.py ali-dev'
alias new-k8s-permission_ali_dev_ask='python3 ./main.py ali-dev-ask'
alias new-k8s-permission_ali_dev_worker='python3 ./main.py ali-dev-worker'
alias new-k8s-permission_ali_prod='python3 ./main.py ali-prod'
alias new-k8s-permission_ali_prod_worker='python3 ./main.py ali-prod-worker'
alias new-k8s-permission_mixbio_dev='python3 ./main.py mixbio-dev'
alias new-k8s-permission_mixbio_prod='python3 ./main_n.py mixbio-prod'

# Helm 上下文快捷别名
alias helm_ali_dev='helm_2_16_3 --kube-context=ali-dev'
alias helm3_ali_dev='helm3 --kube-context=ali-dev'
alias helm_ali_dev_ask='helm_2_16_12 --kube-context=ali-dev-ask'
alias helm3_ali_dev_ask='helm3 --kube-context=ali-dev-ask'
alias helm_ali_dev_worker='helm_2_16_12 --kube-context=ali-dev-worker'
alias helm_ali_prod='helm_2_16_3 --kube-context=ali-prod'
alias helm3_ali_prod='helm3 --kube-context=ali-prod'
alias helm_ali_prod_worker='helm_2_16_12 --kube-context=ali-prod-worker'
alias helm3_ali_prod_worker='helm3 --kube-context=ali-prod-worker'
alias helm_dev='helm_2_9_1 --kube-context=ningxia-dev'
alias helm3_dev='helm3 --kube-context=ningxia-dev'
alias helm_prod='helm_2_9_1 --kube-context=prod'
alias helm_prod_nx='helm_2_9_1 --kube-context=prod-nx'
alias helm_mixbio_dev='helm_2_16_3 --kube-context=mixbio-dev'
alias helm_mixbio_prod='helm_2_16_3 --kube-context=mixbio-prod'
alias helm_azure='helm3 --kube-context=azure-dev1'
alias helm_ali_applyai='helm3 --kube-context=ali-applyai'
alias helm_mycluster='helm3 --kube-context=k3d-mycluster'

# Velero 上下文快捷别名
alias velero_prod='velero --kubecontext=prod'
alias velero_prod_nx='velero --kubecontext=prod-nx'

# Kops 上下文快捷别名
alias bjprod-kops1-15='AWS_REGION=cn-north-1 KOPS_STATE_STORE=s3://alo7-kops/prod kops1.15'
alias mykops1-16='AWS_REGION=cn-northwest-1 KOPS_STATE_STORE=s3://kops-bach-test kops1.16'
alias nxprod-kops1-15='AWS_REGION=cn-northwest-1 KOPS_STATE_STORE=s3://alo7-kops-zhy/prod kops1.15'

### --- 11. P10k 主题加载 ----------------------------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 修复终端鼠标状态（必须在 p10k 初始化之后）
precmd_functions+=(fix_mouse)
