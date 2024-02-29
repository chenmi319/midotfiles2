# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  ag
  aliases
  colored-man-pages
  command-not-found
  encode64
  genpass
  history-substring-search
  safe-paste
  tmux
  vundle
  z
  git
  redis-cli
  nvm
  rvm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# HomeBrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
# HomeBrew END

# edit default editor
export EDITOR=vim
export VISUAL="$EDITOR"
export LESS="-F -g -i -M -R -w -X -z-4"

# for tmux use ssh-agent
fixssh() {
  eval $(tmux show-env    \
    |sed -n 's/^\(SSH_[^=]*\)=\(.*\)/export \1="\2"/p')
}

unsetopt auto_name_dirs

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias mysql57='docker run -it --rm mysql:5.7 env LANG=C.UTF-8 mysql -A'
alias mysql57import='docker run -i --rm mysql:5.7 env LANG=C.UTF-8 mysql -A'
alias psql13='docker run -it --rm postgres:13 psql'
alias psql11='docker run -it --rm postgres:11 psql'
alias psql10='docker run -it --rm postgres:10 psql'
alias redis-cli='docker run -it --rm redis:alpine redis-cli'

# fix failing bck-i-search
#bindkey '^R' history-incremental-search-backward

#alias kube_dev_ningxia='kubectl --kubeconfig ~/.kube/kube_config_ningxia'
#alias kube_prod_beijing='kubectl --kubeconfig ~/.kube/kube_config_pro'
export KUBECONFIG='/Users/chenmi/.kube/chenmi-kube-admin-pro-dev-rw:/Users/chenmi/.kube/chenmi-kube-pro-nx:/Users/chenmi/.kube/chenmi-kube-ali-prod:/Users/chenmi/.kube/chenmi-kube-ali-dev:/Users/chenmi/.kube/chenmi-kube-ali-dev-ask:/Users/chenmi/.kube/chenmi-kube-ali-dev-worker:/Users/chenmi/.kube/eks:/Users/chenmi/.kube/chenmi-kube-ali-prod-worker:/Users/chenmi/.kube/mixbio-dev:/Users/chenmi/.kube/rancher-rke.yaml:/Users/chenmi/.kube/mixbio-rancher.yaml:/Users/chenmi/.kube/mixbio.yaml:/Users/chenmi/.kube/mixbio-rancher.yaml:/Users/chenmi/.kube/mixbio-prod.yaml'
#alias kube_dev_ro='kubectl --kubeconfig ~/.kube/chenmi-kube-pro-dev-ro --context=ningxia-dev'
#alias kube_dev='kubectl --context=ningxia-dev'
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

#alias create_ns_dev='python3 ./main.py nx-dev'
alias create_ns_prod='python3 ./main.py prod'
alias create_ns_prod_nx='python3 ./main.py nx-prod'
alias create_ns_ali_dev='python3 ./main.py ali-dev'
alias create_ns_ali_dev_ask='python3 ./main.py ali-dev-ask'
alias create_ns_ali_dev_worker='python3 ./main.py ali-dev-worker'
alias create_ns_ali_prod='python3 ./main.py ali-prod'
alias create_ns_ali_prod_worker='python3 ./main.py ali-prod-worker'
alias create_ns_mixbio_prod='python3 ./main_n.py mixbio-prod'

#alias new-k8s-permission_dev='python3 ./main.py nx'
alias new-k8s-permission_prod='python3 ./main.py prod'
alias new-k8s-permission_ali_dev='python3 ./main.py ali-dev'
alias new-k8s-permission_ali_dev_ask='python3 ./main.py ali-dev-ask'
alias new-k8s-permission_ali_dev_worker='python3 ./main.py ali-dev-worker'
alias new-k8s-permission_ali_prod='python3 ./main.py ali-prod'
alias new-k8s-permission_ali_prod_worker='python3 ./main.py ali-prod-worker'
alias new-k8s-permission_mixbio_dev='python3 ./main.py mixbio-dev'
alias new-k8s-permission_mixbio_prod='python3 ./main_n.py mixbio-prod'

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

#alias velero_dev='velero --kubecontext=ningxia-dev'
alias velero_prod='velero --kubecontext=prod'
alias velero_prod_nx='velero --kubecontext=prod-nx'

#alias bjdev-kops1-15='AWS_REGION=cn-north-1 KOPS_STATE_STORE=s3://alo7-kops/dev kops1.15'
#alias bjdev-kops1-16='AWS_REGION=cn-north-1 KOPS_STATE_STORE=s3://alo7-kops/dev kops1.16'
alias bjprod-kops1-15='AWS_REGION=cn-north-1 KOPS_STATE_STORE=s3://alo7-kops/prod kops1.15'
alias mykops1-16='AWS_REGION=cn-northwest-1 KOPS_STATE_STORE=s3://kops-bach-test kops1.16'
#alias nxdev-kops1-15='AWS_REGION=cn-northwest-1 KOPS_STATE_STORE=s3://alo7-kops-zhy/dev kops1.15'
alias nxprod-kops1-15='AWS_REGION=cn-northwest-1 KOPS_STATE_STORE=s3://alo7-kops-zhy/prod kops1.15'

#alias tmux='tmux -2 -u'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin"

if kubectl version --client >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

autoload -U +X compinit && compinit -i
autoload -U +X bashcompinit && bashcompinit -i
complete -o nospace -F /usr/local/bin/aliyun aliyun

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="$HOME/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
alias conda=micromamba

try_link(){
  if [[ -a $2 ]]; then mv -f $2 $2.bak.`date +%Y%m%d%H%M%S`; fi
  ln -s $1 $2
}

# git clone git@github.com:chenmi319/midotfiles2.git ~/.midotfiles2, git pull
update_mi_dot_files() {
  cd ~/.midotfiles2
  git pull
  cd -
}

alias genpass='cat /dev/urandom | head -n 16 | shasum | base64 | cut -c1-16'
