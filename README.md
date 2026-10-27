# midotfiles2

# 准备工作

> 主要面向 macOS，Linux 服务器可参考但需自行将 `brew` 替换为 `apt`/`yum` 等包管理器命令。

* 安装 git、curl（macOS 需要 Homebrew 或 Xcode Command Line Tools）
* 安装 [MesloLGS NF 字体](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#fonts) 并在终端中启用（Powerlevel10k 主题需要，装晚了终端会乱码）
* iTerm2：配色使用 Dark Background 即可，避免使用 Solarized Dark 等其他主题
* iTerm2：Preferences → General → Selection → Applications in terminal may access clipboard
* iTerm2：关闭标签页活动指示（tmux 状态栏刷新会触发，改由 tmux 自身的 monitor-activity 提示）：
  - Settings → Appearance → Tabs → 取消勾选 **Show activity indicator** 和 **Show new-output indicator**
  - 或通过命令行设置（重启 iTerm2 生效）：
```bash
defaults write com.googlecode.iterm2 HideActivityIndicator -bool true
defaults write com.googlecode.iterm2 ShowNewOutputIndicator -bool false
```
```bash
git clone https://github.com/chenmi319/midotfiles2.git ~/.midotfiles2
# 已配 SSH key：git clone git@github.com:chenmi319/midotfiles2.git ~/.midotfiles2

# 后续多处用到的软链辅助函数
# 此时 zshrc 尚未链接，需先手动粘贴到当前 shell
try_link() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: try_link <source> <target>" >&2
    return 1
  fi

  if [ ! -e "$1" ] && [ ! -L "$1" ]; then
    echo "try_link: source does not exist: $1" >&2
    return 1
  fi

  mkdir -p "$(dirname "$2")" || return 1

  if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
    return 0
  fi

  if [ -e "$2" ] || [ -L "$2" ]; then
    mv -f "$2" "$2.bak.$(date +%Y%m%d%H%M%S)" || return 1
  fi

  ln -s "$1" "$2"
}
```

> zshrc 已将 `$HOME/bin` 加入 PATH（优先级最高）。在无 root / brew 权限的远程服务器上，
> 可以直接下载预编译二进制到 `~/bin/`，无需包管理器。

```bash
mkdir -p ~/bin

# 示例（Linux x86_64，版本号去各项目 GitHub Releases 页面查看）：
# delta:   https://github.com/dandavison/delta/releases
# ripgrep: https://github.com/BurntSushi/ripgrep/releases
# neovim:  https://github.com/neovim/neovim/releases

# 下载解压后将二进制放入 ~/bin/ 即可，如：
# cp delta ~/bin/
# cp rg ~/bin/
# neovim 有 lib/ 和 share/ 依赖，需保留完整目录并软链接：
# tar xzf nvim-linux-x86_64.tar.gz -C ~/bin/
# ln -sf nvim-linux-x86_64/bin/nvim ~/bin/nvim
```

* ruff 的安装脚本默认装到 `~/.local/bin/`（也在 PATH 中），无需额外操作
* 后续各 section 的 `brew install` / `apt install` 仍然是有包管理器时的首选

# 代理隧道（可选）

> 远程机器无法直接访问 GitHub 等外网时，可通过 SSH 反向隧道借用本地代理。

**本地**（开一个终端保持运行）：
```bash
ssh -N \
  -R 7890:127.0.0.1:7890 \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  <remote-host>
```

**远程**（在需要翻墙的 shell 中执行）：
```bash
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890

# 验证代理是否生效
curl -I https://github.com
```

* `7890` 是 Clash 等代理工具的默认端口，按实际情况修改
* 隧道仅在 SSH 连接存活期间有效，断开后远程端口自动关闭
* 后续所有 `git clone`、`curl` 命令均会自动走代理

# zsh
```bash
# macOS
brew install zsh
# Ubuntu/Debian
# sudo apt install zsh -y

# 安装 oh-my-zsh（若遇权限问题：compaudit | xargs chmod g-w,o-w）
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# oh-my-zsh 插件
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

try_link ~/.midotfiles2/zshrc ~/.zshrc
try_link ~/.midotfiles2/p10k.zsh ~/.p10k.zsh
```


## Python 环境自动选择与手动激活

* `uvs` 只激活当前目录的 `.venv`；`uvsb` 从当前目录逐层向根目录查找最近的 `.venv`，找到后激活它。只有查找途中未遇到项目边界、且所有祖先均没有 `.venv` 时，才使用 `~/.venv`（包括在 home 以外的目录）。
* 项目边界：某层存在 `pyproject.toml`、`uv.lock` 或 `uv.toml` 任一标记，但没有同层 `.venv`，就报错停止，不继续向上或回退默认环境，避免依赖误装。若同层已有 `.venv`，优先使用它；`.python-version` 不作为边界。自动检查遇到此边界时会退出本函数自动激活的环境；手动或继承的 venv、Conda/mamba 环境保留并明确警告。请先创建并激活项目环境，不能忽略错误后直接安装依赖。
* Zsh 启动和每次切目录时通过 `load-uv-venv` 自动选择环境；没有项目环境或边界时激活 `~/.venv`。仅切换本 shell 自动激活的环境，不覆盖手动或继承的环境。退出 venv 使用 `deactivate`，下次切目录恢复自动选择。
* `uvsb` 是显式切换命令，可以替换当前 venv；成功选择后按手动环境保留，即使选中的是当前自动环境。`uvs` 也会取消自动管理。同一环境（含软链接）不重复激活；直接 `source` 同一路径无法识别为手动重激活，需要固定环境时使用 `uvs`/`uvsb`。Conda/mamba 请先用对应命令退出，避免环境叠加。
* 最近的 `.venv` 损坏时直接报错，不跳过它。激活文件缺失或不可读时，自动模式退出自己激活的旧环境，手动调用保留当前环境；脚本执行失败可能已修改 shell 状态，需要检查后重新激活。
* 仅用于可信目录：启动和切目录会自动 `source` 激活脚本，`.venv` 名称不代表可信。可用 `add-zsh-hook -d chpwd load-uv-venv` 暂停切目录检查，但不要在不可信目录启动新 shell。环境切换不修复证书，也不关闭 HTTPS 证书验证。
* 默认环境需事先在 `~/.venv` 创建，项目依赖放各自 `.venv`；不自动创建环境或安装依赖。
* 更新后建议打开新终端。继承的 `VIRTUAL_ENV` 不会被自动接管；若需要恢复自动选择，先 `deactivate`（需在拥有该函数的 shell 中），再切目录或执行 `load-uv-venv`。边界保护不限制包管理器：退出 venv 后仍需先创建项目环境，避免误装到系统 Python。

验证（只使用临时模拟环境，不加载完整 zshrc、不下载 Python）：

```bash
zsh -n zshrc
zsh -f scripts/test-uv-venv.zsh
```

# git
```bash
# macOS
brew install git delta
# Ubuntu/Debian
# sudo apt install git git-delta

try_link ~/.midotfiles2/gitconfig ~/.gitconfig
try_link ~/.midotfiles2/gitignore ~/.gitignore
try_link ~/.midotfiles2/gitmessage ~/.gitmessage

# 创建个人身份配置（修改 name 和 email 后执行）
cat > ~/.gitconfig.user <<'EOF'
[user]
  name = xxx
  email = xxx
EOF
```


# tmux
```bash
# macOS
brew install tmux
# Ubuntu/Debian
# sudo apt install tmux

# 安装 tpm（tmux 插件管理器）
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
try_link ~/.midotfiles2/tmux.conf ~/.tmux.conf
```
* 安装 tmux 插件：进入 tmux 后执行 `prefix + I`（默认 `Ctrl-b` 后按大写 `I`）
* 终端标题显示“会话名:窗口编号 · 当前活动 pane 的程序名”，例如 `apply7-frontend:2 · node`；使用 tmux 原生格式，不依赖插件或 shell 钩子。程序名不包含完整命令参数，Node 程序可能只显示为 `node`。
* iTerm2 的 `(tmux)` 来自独立的 Job 标题元素；若不需要，可在 Settings → Profiles → General → Title 取消 **Job**，保留 **Session Name**，并允许 **Applications in terminal may change the title**。`⌘2` 是标签切换快捷键提示，不受此标题格式影响。


# nvm / Node.js

> Copilot.lua 要求 Node.js >= 22，tree-sitter-cli、prettier 等工具也通过 npm 安装。
> macOS 和 Linux 统一使用 nvm 管理 Node 版本。

```bash
# 安装 nvm（https://github.com/nvm-sh/nvm）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash

# 重新加载 shell 后安装 Node.js 22 LTS
nvm install 22
nvm alias default 22
```

* zshrc 已配置 oh-my-zsh nvm 插件，遇到 `.nvmrc` 文件时自动切换版本
* 若远程机器通过系统包管理器装了旧版 Node，nvm 安装后会优先使用 nvm 管理的版本


# neovim
```bash
# macOS
brew install neovim ripgrep
# Ubuntu/Debian
# sudo apt install neovim ripgrep

# tree-sitter-cli（macOS 也可 brew install tree-sitter-cli）
npm install -g tree-sitter-cli
# Ubuntu 22.04 (GLIBC 2.35)：最新版预编译二进制要求 GLIBC >= 2.39，需指定兼容版本
# npm install -g tree-sitter-cli@0.24.7

try_link ~/.midotfiles2/nvim ~/.config/nvim

# 安装 vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall

# treesitter parser 安装
# macOS 下 nvim 启动时自动编译安装（需要 tree-sitter-cli）
# 远程 Linux 服务器如果 :TSInstall 不工作，用脚本手动编译：
# bash ~/.midotfiles2/scripts/install-ts-parsers.sh      # 首次安装
# bash ~/.midotfiles2/scripts/install-ts-parsers.sh -f   # 强制重装全部

# 日常维护
# nvim +PlugUpdate +qall   # 升级插件
# nvim +PlugClean +qall    # 清理未使用插件

# LSP servers 由 mason.nvim 自动安装（:MasonInstall pyright ruff typescript-language-server 等）
# 外部 formatter（conform.nvim 调用）:
#   ruff:     curl -LsSf https://astral.sh/ruff/install.sh | sh  （或 brew install ruff）
#   prettier: npm install -g prettier
```

* 常用代码跳转：
  - `[i` / `]i`：跳到上一个 / 下一个更小缩进的非空行，适合快速回到外层代码块
  - `[m` / `]m`：跳到上一个 / 下一个函数开头
  - `[[` / `]]`：跳到上一个 / 下一个类开头
  - `gd`：光标位于符号上时跳到定义
  - `<C-o>`：返回上一次跳转前的位置



# bash bashit (for develop, 历史参考)

> **注意**: Bash-it 已进入维护模式 ([Discussion #2346](https://github.com/Bash-it/bash-it/discussions/2346))，不会再有新功能。
> 如果是新环境建议直接用 zsh + oh-my-zsh。以下仅供已有 bash 环境参考。

* run in bash:
```bash
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
```
* 编辑 `~/.bashrc`，设置主题和环境变量:
```bash
# Bash-it 主题（install.sh 默认是 bobby，改为 sexy）
export BASH_IT_THEME='sexy'
export SEXY_THEME_SHOW_PYTHON=true

export VISUAL=vim
export EDITOR="$VISUAL"
export PATH="$PATH:$HOME/bin"

# tmux 256色 + UTF-8（现代终端通常不需要，服务器环境可保留）
alias tmux='tmux -2 -u'
```
* relogin and run in bash:
```bash
# 按需启用，只列你实际用的
bash-it enable completion ssh tmux conda
bash-it enable plugin git history ssh tmux
bash-it enable alias git tmux vim
```
* relogin

# bash liquid (for server)
* run in bash:
```bash
# 使用 stable 分支，避免跟踪开发分支
git clone --branch stable https://github.com/liquidprompt/liquidprompt.git ~/.liquidprompt
echo '[[ $- = *i* ]] && source ~/.liquidprompt/liquidprompt' >> ~/.bashrc
# tmux 256色 + UTF-8（服务器环境下 $TERM 可能不准确，保留作为防御）
echo "alias tmux='tmux -2 -u'" >> ~/.bashrc
try_link ~/.midotfiles2/liquidpromptrc ~/.liquidpromptrc
```
* relogin

# mac
```bash
# 所有控件启用完整键盘访问（如在对话框中用 Tab 切换按钮）
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# 关闭长按弹出字符选择面板，改为按键重复
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# 按键重复速率（KeyRepeat=1 ≈ 15ms，InitialKeyRepeat=15 ≈ 225ms）
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```
* 修改后需注销并重新登录才能生效
