" ============================================================================
" Pre-plugin Settings
" ============================================================================

" Python 缩进修复：默认 shiftwidth()*2 导致 { 后缩进 8 格
" NOTE: treesitter indent 启用时优先用 treesitter，此为 fallback
" 参考: https://github.com/vim/vim/blob/master/runtime/autoload/python.vim
let g:python_indent = { 'open_paren': 'shiftwidth()' }

" ============================================================================
" Plugins (vim-plug)
" ============================================================================

call plug#begin()

" appearance
Plug 'navarasu/onedark.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'catgoose/nvim-colorizer.lua'
Plug 'ryanoasis/vim-devicons'                   " NOTE: 仅供 NERDTree 使用；迁移 nvim-tree 时删除
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'HiPhish/rainbow-delimiters.nvim'

" treesitter
" NOTE: main 分支需要 tree-sitter-cli (>= 0.26.1) 才能 :TSInstall/:TSUpdate
"   macOS: brew install tree-sitter-cli
"   Ubuntu: sudo apt install tree-sitter-cli  (24.04+, check version >= 0.26.1)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'  " mini.ai treesitter text objects 所需的查询文件

" git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" navigation
Plug 'preservim/nerdtree'
Plug 'chenmi319/vim-nerdtree-tabs'
Plug 'hedyhli/outline.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'folke/flash.nvim'

" search
" NOTE: vim-visual-star-search 已移除 — 由内联 Lua 替代（见 lua << EOF 块）

" editing
" NOTE: tcomment_vim 已移除 — Nvim 0.10+ 内置: gc{motion}, gcc, gcip (≈gcp)
Plug 'kylechui/nvim-surround'
Plug 'tpope/vim-abolish'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'echasnovski/mini.align'
Plug 'andymass/vim-matchup'
Plug 'echasnovski/mini.ai'
" NOTE: textobj-word-column.vim 已移除 — 已废弃；ic/ac 与内置注释 text object 冲突

" session / integration
Plug 'rmagatti/auto-session'
Plug 'christoomey/vim-tmux-navigator'


" filetype
Plug 'MeanderingProgrammer/render-markdown.nvim'

" ai
Plug 'github/copilot.vim'

" lsp / completion
" https://github.com/neoclide/coc.nvim
" 安装 node, 安装 nvm, nvm install 22, 设置 nvm alias default 22, npm install -g yarn
" cd ~/.vim/bundle/coc.nvim; yarn install --frozen-lockfile
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" in vim :CocInstall coc-calc coc-diagnostic coc-json coc-xml coc-yaml coc-pairs coc-prettier coc-lists
" in vim ondemand :CocInstall coc-pyright @yaegassy/coc-ruff coc-tsserver coc-sh coc-docker @yaegassy/coc-nginx coc-sql coc-html @yaegassy/coc-tailwindcss3 coc-solargraph
" other common plugin: coc-java coc-perl coc-clangd coc-markdownlint

call plug#end()

" ============================================================================
" General Settings
" ============================================================================

set termguicolors
set number
set cursorline
set noshowmode
set gcr=a:blinkon0

" 会话选项 - 控制 session 保存/恢复的内容
set sessionoptions-=options  " 不保存全局选项（防止插件冲突）
set sessionoptions-=folds    " 不保存折叠状态
set sessionoptions-=blank    " 不保存空窗口
set sessionoptions+=tabpages,winsize,curdir

" 持久化 undo，避免误关丢历史
set undofile
if isdirectory(expand('~/.vim/undo')) == 0
  silent! call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif
set undodir=~/.vim/undo
" swap 用单独位置（可选）
if isdirectory(expand('~/.vim/swap')) == 0
  silent! call mkdir(expand('~/.vim/swap'), 'p', 0700)
endif
set directory=~/.vim/swap//

set smartindent
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set list listchars=tab:>-,trail:-,nbsp:␣
set wrap
set linebreak
set foldmethod=indent
set foldnestmax=3
set nofoldenable
set wildmode=list:longest
set wildignore=*.o,*.obj,*~
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set scrolloff=8
set sidescrolloff=15
set sidescroll=1
set ignorecase
set smartcase
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set cmdheight=1
set mouse=nv
set completeopt=menu,menuone
nnoremap <F7> :set paste!<CR>:set paste?<CR>
set grepprg=git\ grep
let g:grep_cmd_opts = '--line-number'
" NOTE: 仅支持 Linux/macOS，Windows 需自行配置 clipboard
set clipboard=unnamedplus
let mapleader=","
map <leader>bd :bd<CR>

" ============================================================================
" Plugin Configurations (VimL)
" ============================================================================

" navarasu/onedark.nvim — 配置见 lua << EOF 块
colorscheme onedark

" jistr/vim-nerdtree-tabs.git
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_open_on_new_tab = 1
map <silent> <leader>tn :NERDTreeTabsToggle<CR>

" scrooloose/nerdtree.git
let g:NERDTreeIgnore = ['^__pycache__$', 'Session.vim', '.DS_Store']

" catgoose/nvim-colorizer.lua — 配置见 lua << EOF 块

" folke/flash.nvim — 配置见 lua << EOF 块

" nvim-telescope/telescope.nvim
" 用 Telescope 搜索文件、内容、buffer 等
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fF <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fA <cmd>Telescope find_files hidden=true no_ignore=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" fannheyward/telescope-coc.nvim（完整子命令列表 :Telescope coc）
nnoremap <leader>fr <cmd>Telescope coc references<cr>
nnoremap <leader>fd <cmd>Telescope coc definitions<cr>
nnoremap <leader>fc <cmd>Telescope coc declarations<cr>
nnoremap <leader>fi <cmd>Telescope coc implementations<cr>
nnoremap <leader>ft <cmd>Telescope coc type_definitions<cr>
nnoremap <leader>fa <cmd>Telescope coc diagnostics<cr>
nnoremap <silent> tt :Telescope resume<cr>

" tpope/vim-abolish
" 按 crs 转 snake_case, crm MixedCase, crc camelCase, cru UPPER_CASE, cr- dash-case, cr. dot.case

" kylechui/nvim-surround — 配置见 lua << EOF 块
" 用法: ys{motion}{char} 添加, ds{char} 删除, cs{旧}{新} 替换
"   ysiw) → (word)  ysiw( → ( word )  ds" → 删除引号  cs'" → ' 换成 "
"   ysiwf → function_name(word)  dst → 删除 HTML 标签

" NOTE: vim-unimpaired 已移除 — Nvim 0.11+ 内置: [b ]b [q ]q [l ]l [a ]a [f ]f [n ]n [d ]d
" [e/]e（交换行）和 [<Space>/]<Space>（插入空行）由内联 Lua 替代

" HiPhish/rainbow-delimiters.nvim（Lua 配置在底部）

" tpope/vim-fugitive
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete

" echasnovski/mini.align — 配置在 lua << EOF 块

" AndrewRadev/splitjoin.vim
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" christoomey/vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" lewis6991/gitsigns.nvim (lua config at bottom)

" nvim-treesitter/nvim-treesitter-context (lua config at bottom)
nnoremap <silent> tc :TSContext toggle<CR>

" github/copilot.vim
let g:copilot_enabled = 1
inoremap <C-e> <Plug>(copilot-next)
inoremap <Leader>n <Plug>(copilot-next)
inoremap <Leader>p <Plug>(copilot-prev)
inoremap <leader>a <Plug>(copilot-accept)
let g:copilot_filetypes = {
    \ '*': v:true,
    \ }
let g:copilot_tab_fallback = ""

" ============================================================================
" Custom Keybindings
" ============================================================================

" --- paste / register / clipboard
vnoremap <leader>p "0p
vnoremap <leader>P "0P
nnoremap <leader>Y :%y+<CR>
nnoremap 0 ^
nnoremap ^ 0

" --- surround 快捷键（leader + 括号/引号包裹）
map ," ysiw"
vmap ," c"<C-R>""<ESC>
map ,' ysiw'
vmap ,' c'<C-R>"'<ESC>
map ,( ysiw(
map ,) ysiw)
vmap ,( c( <C-R>" )<ESC>
vmap ,) c(<C-R>")<ESC>
map ,] ysiw]
map ,[ ysiw[
vmap ,[ c[ <C-R>" ]<ESC>
vmap ,] c[<C-R>"]<ESC>
map ,} ysiw}
map ,{ ysiw{
vmap ,} c{ <C-R>" }<ESC>
vmap ,{ c{<C-R>"}<ESC>
map ,` ysiw`
nnoremap ,. '.

" --- emacs 风格快捷键（插入模式 + 命令行模式）
inoremap <C-a> <C-O><S-i>
inoremap <C-e> <End>  " NOTE: 被 copilot <C-e> 映射覆盖
inoremap <C-b> <LEFT>
inoremap <C-f> <RIGHT>
inoremap <C-h> <BACKSPACE>
inoremap <C-d> <DELETE>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>
cnoremap <C-b> <LEFT>
cnoremap <C-f> <RIGHT>
cnoremap <C-h> <BACKSPACE>
cnoremap <C-d> <DELETE>

" --- NERDTree / 窗口管理
" <C-\>: 智能切换 — 在所有 tab 中打开 NERDTree 并定位文件，或全局切换
"   使用 NERDTreeTabs 命令保持跨 tab 同步（与 <leader>tn 一致）
function! OpenNerdTree()
  if &modifiable && strlen(expand('%')) > 0 && !&diff
    let l:file = expand('%:p')
    NERDTreeTabsOpen
    exe 'NERDTreeFind ' . fnameescape(l:file)
  else
    NERDTreeTabsToggle
  endif
endfunction
nnoremap <silent> <C-\> :call OpenNerdTree()<CR>
nmap <silent> ,qc :cclose<CR>
nmap <silent> ,qo :copen<CR>
nnoremap <C-w>f :sp +e<cfile><CR>
nnoremap <C-w>gf :tabe<cfile><CR>
map <silent> ,gz <C-w>o
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" --- 路径复制（,c 前缀: f=从~开始, r=相对, n=文件名, s=短/相对, l=长/绝对）
" NOTE: ,cr 和 ,cs 在 normal 模式下功能相同（都是相对路径），保留冗余方便记忆
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>
nnoremap <silent> ,cr :let @* = expand("%")<CR>
nnoremap <silent> ,cn :let @* = expand("%:t")<CR>
nnoremap <silent> ,cs :let @* = expand("%")<CR>
nnoremap <silent> ,cl :let @* = expand("%:p")<CR>
" visual: 复制路径:行号范围 + 选中内容 (s=short/相对, l=long/绝对)
xnoremap <silent> ,cs :<C-u>let @* = expand("%") . ":" . line("'<") . "-" . line("'>") . "\n" . join(getline(line("'<"), line("'>")), "\n")<CR>
xnoremap <silent> ,cl :<C-u>let @* = expand("%:p") . ":" . line("'<") . "-" . line("'>") . "\n" . join(getline(line("'<"), line("'>")), "\n")<CR>

" --- 搜索 / 标记
nmap <silent> // :nohlsearch<CR>
nnoremap ' `
nnoremap ` '

" --- tab 管理
nnoremap <C-t>c :tabnew<CR>
nnoremap <silent> H :tabprevious<CR>
nnoremap <silent> L :tabnext<CR>
nnoremap ˙ gT
nnoremap ¬ gt
let g:lasttab = 1
nnoremap <silent> T :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <leader>1 1gt
nnoremap <silent> <leader>2 2gt
nnoremap <silent> <leader>3 3gt
nnoremap <silent> <leader>4 4gt
nnoremap <silent> <leader>5 5gt
nnoremap <silent> <leader>6 6gt
nnoremap <silent> <leader>7 7gt
nnoremap <silent> <leader>8 8gt
nnoremap <silent> <leader>9 9gt
nnoremap <silent> <leader>0 :tablast<CR>

" --- 可视模式 / 导航 / 杂项
vnoremap < <gv
vnoremap > >gv
nnoremap j gj
nnoremap k gk
inoremap <expr> <c-j> pumvisible() ? "\<C-e>\<Down>" : "\<Down>"
inoremap <expr> <c-k> pumvisible() ? "\<C-e>\<Up>" : "\<Up>"
nmap <silent> <leader>> ciw<Esc>:let @"=substitute(strtrans(@"), '[A-Z]\C', '_\L&', 'g')<CR>"0p
nmap <silent> <leader>< ciw<Esc>:let @"=substitute(strtrans(@"), '_\([a-z]\)\C', '\U\1', 'g')<CR>"0p
map <leader>ww :w<CR>
map <leader>xx :x<CR>
map <leader>qq :qa<CR>
nnoremap <F8> :set wrap! wrap?<CR>
imap <F8> <C-O><F8>
" 显示不可见字符
" highlight nonascii guibg=Red ctermbg=2
" autocmd BufReadPost * syntax match nonascii "[^\u0000-\u007F]"
command! NonASCIIHighlight exec 'syntax match nonascii "[^\u0000-\u007F]"' | hi nonascii ctermbg=2 guibg=Red

" ============================================================================
" CoC (neoclide/coc.nvim)
" ============================================================================

nmap <leader>rs :CocRestart<CR>
" 某些 LSP 不兼容 backup 文件，见 coc.nvim #649
set nobackup
set nowritebackup

" updatetime 过长会导致延迟（默认 4000ms），影响体验
set updatetime=300

" 始终显示 signcolumn，避免诊断信息出现时文本抖动
set signcolumn=yes

" Tab 触发补全并导航补全列表
" NOTE: 用 ':verbose imap <tab>' 检查 tab 是否被其他插件占用
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 回车确认补全项
" <C-g>u 断开 undo 链
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <C-Space> 手动触发补全
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" [g / ]g 诊断导航
" 完整诊断列表 :CocDiagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" 代码跳转
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" K 显示文档悬浮窗
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 光标停留时高亮当前符号及其引用
autocmd CursorHold * silent call CocActionAsync('highlight')

" 重命名符号
nmap <leader>rn <Plug>(coc-rename)

" 格式化选中代码
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " 设置指定文件类型的 formatexpr
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " 跳转到占位符时更新签名帮助
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" 对选中代码执行 code action
" 示例: <leader>aap 对当前段落执行
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 光标位置的 code action
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" 整个 buffer 的 code action
nmap <leader>as  <Plug>(coc-codeaction-source)
" 自动修复当前行的诊断
nmap <leader>qf  <Plug>(coc-fix-current)

" 重构
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Code Lens（已禁用）
" nmap <leader>cl  <Plug>(coc-codelens-action)

" 函数/类 text object（需要 LSP 支持 textDocument.documentSymbol）
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" <C-f>/<C-b> 滚动浮动窗口/弹出菜单
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" <C-s> 选择范围（需要 LSP 支持 textDocument/selectionRange）
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" :Format 格式化当前 buffer
command! -nargs=0 Format :call CocActionAsync('format')

" :Fold 折叠当前 buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" :OR 整理当前 buffer 的 import
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" CocList 快捷键
" 所有诊断
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" 管理扩展
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" 命令列表
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" 当前文件的符号大纲
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" 搜索工作区符号
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" 搜索工作区文件
nnoremap <silent><nowait> <space>f  :<C-u>CocList files<cr>
" 下一项操作（已禁用）
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" 上一项操作（已禁用）
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" 恢复上次 CocList
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
nnoremap <silent> to :Outline<CR>

" 切换 pyright inlay hints（tv=变量类型, tp=参数类型）
function! TogglePyrightInlayHints(kind, config_key)
    if &filetype != 'python'
        echo 'Not a Python file.' | return
    endif
    let state_var = 'g:pyright_inlay' . a:kind . 'Hints_state'
    if !exists(state_var) | let {state_var} = v:false | endif
    let {state_var} = !{state_var}
    call CocAction('updateConfig', 'pyright.inlayHints.' . a:config_key, {state_var})
    echo 'pyright.inlayHints.' . a:config_key . ': ' . ({state_var} ? 'on' : 'off')
endfunction

let g:pyright_inlayVariableHints_state = v:true
nnoremap <silent> tv :call TogglePyrightInlayHints('Variable', 'variableTypes')<CR>
nnoremap <silent> tp :call TogglePyrightInlayHints('Parameter', 'parameterTypes')<CR>
" 切换当前 buffer 所有 inlay hints（th, coc.nvim 内置，适用所有文件类型）
nnoremap <silent> th :CocCommand document.toggleInlayHint<CR>

" 切换 coc 扩展（tr=coc-ruff）
function! ToggleCocExtension(extension)
    call CocAction('toggleExtension', a:extension)
    let l:status = CocAction('extensionStats')
    for ext in l:status
        if has_key(ext, 'id') && ext.id ==# a:extension
            echo a:extension . (ext.state ==# 'activated' ? ' enabled' : ' disabled')
            return
        endif
    endfor
    echo 'Extension ' . a:extension . ' not found.'
endfunction
nnoremap <silent> tr :call ToggleCocExtension('@yaegassy/coc-ruff')<CR>

" ============================================================================
" Lua Plugin Configurations
" ============================================================================

lua << EOF

-- 重新打开文件时恢复光标位置（替代 lastpos.vim）
-- NOTE: 必须在插件 setup 之前注册，确保能捕获启动时的 buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0)
      and not vim.bo.filetype:match('commit') then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- navarasu/onedark.nvim
require('onedark').setup({
  style = 'dark',
  highlights = {
    IblScope = { fg = '$grey', fmt = 'nocombine' },  -- scope 线: 用灰色替代默认紫色
  },
})
require('onedark').load()

-- nvim-tree/nvim-web-devicons
require('nvim-web-devicons').setup()

-- kylechui/nvim-surround（替代 vim-surround）
require('nvim-surround').setup()

-- echasnovski/mini.ai（替代 targets.vim）
-- 内置 text objects: a( a[ a{ a< a" a' a` aq(任意引号) ab(任意括号) af(函数调用) aa(参数) at(标签)
-- 增强: 光标不在目标内时自动 seek forward (search_method = 'cover_or_next')
-- treesitter text objects: F=函数定义 o=条件/循环 c=类
local ts = require('mini.ai').gen_spec.treesitter
require('mini.ai').setup({
  n_lines = 100,
  custom_textobjects = {
    F = ts({ a = '@function.outer', i = '@function.inner' }),
    o = ts({ a = { '@conditional.outer', '@loop.outer' }, i = { '@conditional.inner', '@loop.inner' } }),
    c = ts({ a = '@class.outer', i = '@class.inner' }),
  },
})

-- echasnovski/mini.align（替代 vim-easy-align）
-- 选中多行后 ga 进入对齐模式，输入分隔符即可：
--   V选中 → ga → =    按 = 对齐赋值语句
--   V选中 → ga → :    按 : 对齐 YAML/字典
--   V选中 → ga → #    按 # 对齐行尾注释
--   V选中 → gA → =    带实时预览的对齐（推荐）
-- 修饰键（在输入分隔符前按）: s=正则 j=切换方向 t=trim空白 i=忽略字符串/注释
require('mini.align').setup({
  mappings = {
    start = 'ga',
    start_with_preview = 'gA',
  },
})

-- vim-unimpaired 替代（Nvim 0.11+ 内置 [b ]b [q ]q 等）
-- [e / ]e: 向上/下交换当前行（支持 count，如 3]e 向下移 3 行）
vim.keymap.set('n', '[e', function()
  if vim.v.count == 0 then vim.cmd('move .-2') else vim.cmd('move .-' .. (vim.v.count + 1)) end
  vim.cmd('normal! ==')
end, { desc = 'Move line up' })
vim.keymap.set('n', ']e', function()
  if vim.v.count == 0 then vim.cmd('move .+1') else vim.cmd('move .+' .. vim.v.count) end
  vim.cmd('normal! ==')
end, { desc = 'Move line down' })
-- [<Space> / ]<Space>: 在上方/下方插入空行（支持 count，如 3[<Space> 插入 3 行）
vim.keymap.set('n', '[<Space>', function()
  for _ = 1, math.max(vim.v.count, 1) do vim.fn.append(vim.fn.line('.') - 1, '') end
end, { desc = 'Blank line above' })
vim.keymap.set('n', ']<Space>', function()
  for _ = 1, math.max(vim.v.count, 1) do vim.fn.append(vim.fn.line('.'), '') end
end, { desc = 'Blank line below' })

-- nvim-lualine/lualine.nvim（替代 lightline.vim）
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
  end
end

require('lualine').setup({
  options = {
    theme = 'auto',
    globalstatus = true,    -- 所有分屏共用一个状态栏（Nvim 0.7+）
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'FugitiveHead', icon = '' },
      { 'diff', source = diff_source },
      { 'diagnostics', sources = { 'coc' } },
    },
    lualine_c = {
      { 'filename', path = 1, symbols = { readonly = '[RO]', modified = '[+]' } },
      'filesize',
      'g:coc_status',
      'b:coc_current_function',
    },
    lualine_x = { 'fileformat', 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_c = { { 'filename', path = 1 } },
  },
  tabline = {
    lualine_a = {
      { 'tabs', mode = 2, path = 1, tab_max_length = 16, max_length = vim.o.columns },
    },
  },
  extensions = { 'nerdtree', 'fugitive', 'quickfix' },
})

-- coc 状态变化时刷新 lualine
vim.api.nvim_create_autocmd('User', {
  pattern = { 'CocStatusChange', 'CocDiagnosticChange' },
  callback = function() require('lualine').refresh() end,
})

-- 可视模式 * 和 # 搜索选中文本（替代 vim-visual-star-search）
vim.keymap.set('x', '*', function()
  vim.cmd('normal! "vy')
  local search = vim.fn.escape(vim.fn.getreg('v'), '/\\')
  vim.fn.setreg('/', '\\V' .. search)
  vim.cmd('normal! n')
end)
vim.keymap.set('x', '#', function()
  vim.cmd('normal! "vy')
  local search = vim.fn.escape(vim.fn.getreg('v'), '?\\')
  vim.fn.setreg('/', '\\V' .. search)
  vim.cmd('normal! N')
end)

-- catgoose/nvim-colorizer.lua
require('colorizer').setup({
  filetypes = { '*' },
  options = {
    parsers = {
      css = false,
      names = { enable = false },
      hex = { default = true },
    },
  },
})

-- folke/flash.nvim
-- 替代 vim-easymotion；labels 复用原 EasyMotion_keys
require('flash').setup({
  labels = 'asdfjkoweriop',
  modes = {
    char = {
      jump_labels = true,       -- f/t/F/T 在所有匹配处显示跳转标签
    },
  },
})
-- s: 输入字符搜索 + 标签跳转（替代 ,,f{char}, ,,w, ,,b）
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
-- S: 选择 treesitter 节点；;/, 扩大/缩小选区
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
-- r: 远程操作 — 如 yr 然后选目标，执行 iw，文本会被复制到光标处
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
-- <C-s>: 在 / 或 ? 搜索时切换 flash 标签
vim.keymap.set({ 'c' }, '<C-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })

-- lewis6991/gitsigns.nvim
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- ]c / [c: 跳到下/上一个修改块 (hunk)，diff 模式下保持原生行为
    map('n', ']c', function()
      if vim.wo.diff then vim.cmd.normal({']c', bang = true})
      else gs.nav_hunk('next') end
    end)
    map('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal({'[c', bang = true})
      else gs.nav_hunk('prev') end
    end)

    -- ,hp: 弹窗预览当前 hunk 的 diff
    map('n', '<leader>hp', gs.preview_hunk)
    -- ,hb: 显示当前行完整 blame 信息
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end)
    -- ,hd: 分屏 diff 当前文件（与 index 对比）
    map('n', '<leader>hd', gs.diffthis)
    -- ,hD: 分屏 diff 当前文件（与上一个 commit 对比）
    map('n', '<leader>hD', function() gs.diffthis('~') end)

    -- ,th: toggle 修改行高亮 (highlight)
    map('n', '<leader>th', gs.toggle_linehl)
    -- ,tb: toggle 行尾 inline blame
    map('n', '<leader>tb', gs.toggle_current_line_blame)

    -- ih: text object 选中当前 hunk，如 vih 选中、yih 复制、dih 删除
    map({'o', 'x'}, 'ih', gs.select_hunk)
  end
})

-- auto-session
local has_auto_session, auto_session = pcall(require, 'auto-session')
if has_auto_session then
  auto_session.setup({
    root_dir = vim.fn.stdpath('state') .. '/sessions/',
    -- 黑名单模式：不设 allowed_dirs，大部分目录自动保存 session
    suppressed_dirs = {
      '/', '~/', '~/Desktop', '~/Downloads', '~/Documents',
      '/tmp', '/private/tmp', '/private/var',
    },
    bypass_save_filetypes = {
      'gitcommit', 'gitrebase',   -- git 操作
      'help', 'man', 'qf',       -- 只读 / 临时 buffer
      'TelescopePrompt', 'NvimTree', 'nerdtree',  -- 插件 UI
    },
    session_lens = {
      load_on_setup = false,
    },
  })
end

-- fannheyward/telescope-coc.nvim
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = require("telescope.actions").select_tab_drop,
        ["<C-o>"] = require("telescope.actions").select_default,
      },
    },
  },
  extensions = {
    coc = {
        theme = 'ivy',
        prefer_locations = true,
    }
  },
})
require('telescope').load_extension('coc')

-- lukas-reineke/indent-blankline.nvim
require("ibl").setup()

-- nvim-treesitter (main branch API)
-- 安装 parser（已安装则跳过；异步执行）
require('nvim-treesitter').install({ 'python', 'lua', 'json', 'yaml', 'bash', 'markdown', 'javascript', 'typescript', 'tsx', 'html' })

-- 为已安装语言启用 treesitter 高亮 + 缩进
-- NOTE: lua/markdown 由 Neovim 0.12 ftplugin 自动启用；这里列出是为了完整性
local ts_filetypes = { 'python', 'lua', 'json', 'yaml', 'sh', 'markdown', 'javascript', 'typescript', 'typescriptreact', 'html' }
vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_filetypes,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- HiPhish/rainbow-delimiters.nvim: 零配置，默认设置即可

-- vim-matchup（treesitter 集成）
vim.g.matchup_treesitter_enabled = 1
vim.g.matchup_matchparen_offscreen = { method = "popup" }
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_deferred_show_delay = 50
vim.g.matchup_matchparen_deferred_hide_delay = 700

-- nvim-treesitter-context
require('treesitter-context').setup({
  enable = true,
  separator = "-",
  mode = "cursor"
})

-- hedyhli/outline.nvim
local has_outline, outline = pcall(require, 'outline')
if has_outline then
  outline.setup({
    outline_window = {
      position = 'right',
      width = 25,
      auto_close = false,
      show_numbers = false,
      show_relative_numbers = false,
    },
    symbol_folding = {
      autofold_depth = false,
    },
    providers = {
      priority = { 'coc', 'markdown', 'norg', 'man' },
    },
  })
end

EOF
