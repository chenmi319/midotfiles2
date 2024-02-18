# midotfiles2

# 准备工作
* 安装 tmux, zsh, git, nvim, curl
```bash
git clone git@github.com:chenmi319/midotfiles2.git ~/.midotfiles2
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

tryLink(){
  if [[ -a $2 ]]; then mv -f $2 $2.bak.`date +%Y%m%d%H%M%S`; fi
  ln -s $1 $2
}
tryLink ~/.midotfiles2/zshrc ~/.zshrc
tryLink ~/.midotfiles2/p10k.zsh ~/.p10k.zsh
```



# git
* [安装 git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 或者 [下载 git](https://git-scm.com/downloads)
```bash
tryLink ~/.midotfiles2/gitconfig ~/.gitconfig
tryLink ~/.midotfiles2/gitignore ~/.gitignore
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
tryLink ~/.midotfiles2/tmux.conf ~/.tmux.conf
```
* 安装 tmux 插件, 进入 tmux 后执行 `prefix + I`


# vim
* [安装 neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
```bash
mkdir -p ~/.config/nvim/init.vim
tryLink ~/.midotfiles2/vimrc ~/.config/nvim/init.vim
tryLink ~/.midotfiles2/coc-settings.json ~/.config/nvim/coc-settings.json

# 安装 nvim 插件
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginClean +qall
vim +PluginInstall +qall
# 升级
vim +PluginUpdate +qall

# 安装 coc.vim 插件
# 参考 vimrc 里面的配置, :CocInstall coc-calc coc-diagnostic coc-docker coc-git coc-pyright coc-json @yaegassy/coc-nginx coc-sh coc-solargraph coc-xml coc-yaml coc-highlight coc-pairs @yaegassy/coc-ruff coc-spell-checker
```
