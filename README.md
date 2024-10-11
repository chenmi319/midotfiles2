# midotfiles2

# 准备工作
* 安装 git, curl
* ITerm2 使用 DarkBackground 就可以了，不用 Solarized Dark
* ITerm2 Preferences -> Selection -> Applications in terminal may access clipboard
```bash
# git clone git@github.com:chenmi319/midotfiles2.git ~/.midotfiles2
git clone https://github.com/chenmi319/midotfiles2.git ~/.midotfiles2
```

# zsh
* 安装zsh
```bash
# 安装 oh-my-zsh, 有文件夹权限问题，参考修改代码: compaudit | xargs chmod g-w,o-w
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# oh-my-zsh 插件
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
# powerlevel10k 用到字体安装: https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#fonts
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

try_link(){
  if [[ -a $2 ]]; then mv -f $2 $2.bak.`date +%Y%m%d%H%M%S`; fi
  ln -s $1 $2
}
try_link ~/.midotfiles2/zshrc ~/.zshrc
try_link ~/.midotfiles2/p10k.zsh ~/.p10k.zsh
```



# git
* [安装 git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 或者 [下载 git](https://git-scm.com/downloads)
```bash
try_link ~/.midotfiles2/gitconfig ~/.gitconfig
try_link ~/.midotfiles2/gitignore ~/.gitignore
try_link ~/.midotfiles2/gitmessage ~/.gitmessage
```
you should create ~/.gitconfig.user like
```
[user]
  name = xxx
  email = xxx
```


# tmux
* [安装 tmux](https://github.com/tmux/tmux/wiki/Installing)
```bash
# mac 需要安装 reattach-to-user-namespace
HOMEBREW_NO_AUTO_UPDATE=1 brew install reattach-to-user-namespace
# 安装 tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
try_link ~/.midotfiles2/tmux.conf ~/.tmux.conf
```
* 安装 tmux 插件, 进入 tmux 后执行 `prefix + I`


# vim
* [安装 neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
* [安装 nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)
* 安装 ripgrep
* 安装 node, 安装 nvm, nvm install 20, 设置 nvm alias default 20, npm install -g yarn
```bash
mkdir -p ~/.config/nvim/init.vim
try_link ~/.midotfiles2/vimrc ~/.config/nvim/init.vim
try_link ~/.config/nvim/init.vim ~/.vimrc
try_link ~/.midotfiles2/coc-settings.json ~/.config/nvim/coc-settings.json

# 安装 nvim 插件
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim +PlugInstall +qall
# 升级
vim +PlugUpdate +qall
# 清理
vim +PlugClean +qall

# 安装 autopep8 和 ruff
conda activate base
pip install yapf ruff ruff-lsp
ln -s `which yapf` ~/bin/yapf
ln -s `which ruff` ~/bin/ruff
ln -s `which ruff-lsp` ~/bin/ruff-lsp
conda deactivate

# 安装 coc.nvim 以及插件
cd ~/.vim/bundle/coc.nvim; yarn install --frozen-lockfile
# 参考 vimrc 里面的配置
# vim 里运行 :CocInstall coc-calc coc-diagnostic coc-git coc-json coc-xml coc-yaml coc-pairs coc-lists
# vim 里按需运行 :CocInstall coc-pyright @yaegassy/coc-ruff coc-tsserver coc-solargraph coc-sh coc-docker @yaegassy/coc-nginx coc-markdownlint coc-sql coc-html @yaegassy/coc-tailwindcss3  coc-prettier
# 删除: :CocList extensions, 然后 tab
```



# bash bashit(for develop)
* run in bash:
```
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
 ~/.bash_it/install.sh
```
* relogin and run in bash:
```
bash-it enable completion bundler capistrano rake ssh tmux conda
bash-it enable plugin git git-subrepo history nginx rails ruby rvm ssh tmux
bash-it enable alias git rails tmux vim
echo "export VISUAL=vim" >> ~/.bashrc
echo "export EDITOR=\"\$VISUAL\"" >> ~/.bashrc
echo "alias tmux='tmux -2 -u'" >> ~/.bashrc
sed -i 's/bobby/sexy/g' ~/.bashrc
echo "export SEXY_THEME_SHOW_PYTHON=true" >> ~/.bashrc
echo "export PATH=\"\$PATH:\$HOME/bin\"" >> ~/.bashrc
```
* relogin

# bash liquid(for server)
* run in bash:
```
git clone https://github.com/nojhan/liquidprompt.git ~/.liquidprompt
echo '[[ $- = *i* ]] && source ~/.liquidprompt/liquidprompt' >> ~/.bashrc
echo "alias tmux='tmux -2 -u'" >> ~/.bashrc
try_link ~/.midotfiles/liquidpromptrc ~/.liquidpromptrc
```
* relogin
