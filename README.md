# midotfiles2

# 准备工作
* 安装 git, curl
* ITerm2 使用 DarkBackground 就可以了，不用 Solarized Dark
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
# 安装 tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
try_link ~/.midotfiles2/tmux.conf ~/.tmux.conf
```
* 安装 tmux 插件, 进入 tmux 后执行 `prefix + I`


# vim
* [安装 neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
* [安装 nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)
* 安装 ripgrep
* 安装 node 16(默认会设置为 default), npm install -g yarn
```bash
mkdir -p ~/.config/nvim/init.vim
try_link ~/.midotfiles2/vimrc ~/.config/nvim/init.vim
try_link ~/.midotfiles2/coc-settings.json ~/.config/nvim/coc-settings.json

# 安装 nvim 插件
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginClean +qall
vim +PluginInstall +qall
# 升级
vim +PluginUpdate +qall

# 安装 coc.nvim 以及插件
cd ~/.vim/bundle/coc.nvim; yarn install --frozen-lockfile
# 参考 vimrc 里面的配置
# vim 里运行 :CocInstall coc-calc coc-diagnostic coc-docker coc-git coc-pyright coc-json @yaegassy/coc-nginx coc-sh coc-solargraph coc-xml coc-yaml coc-highlight coc-pairs @yaegassy/coc-ruff
# 打开 python 文件后 vim 里需要运行 :CocCommand ruff.builtin.installServer
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
