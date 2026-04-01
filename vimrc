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
Plug 'folke/trouble.nvim'
Plug 'folke/flash.nvim'

" search
" NOTE: vim-visual-star-search 已移除 — 由内联 Lua 替代（见 lua << EOF 块）

" editing
" NOTE: tcomment_vim 已移除 — Nvim 0.10+ 内置: gc{motion}, gcc, gcip (≈gcp)
Plug 'kylechui/nvim-surround'
Plug 'gregorias/coerce.nvim', { 'tag': 'v1.1' }

Plug 'Wansmer/treesj'
Plug 'echasnovski/mini.align'
Plug 'andymass/vim-matchup'
Plug 'echasnovski/mini.ai'
" NOTE: textobj-word-column.vim 已移除 — 已废弃；ic/ac 与内置注释 text object 冲突

" session / integration
Plug 'rmagatti/auto-session'
Plug 'mrjones2014/smart-splits.nvim'


" filetype
Plug 'MeanderingProgrammer/render-markdown.nvim'

" ai
Plug 'zbirenbaum/copilot.lua'

" lsp / completion
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'
Plug 'saghen/blink.cmp', { 'tag': 'v1.*' }
Plug 'rafamadriz/friendly-snippets'
Plug 'fang2hou/blink-copilot'
Plug 'stevearc/conform.nvim'
Plug 'windwp/nvim-autopairs'

call plug#end()

" ============================================================================
" General Settings
" ============================================================================

set number
set cursorline
set noshowmode
set guicursor=a:blinkon0

" 会话选项 - 控制 session 保存/恢复的内容
set sessionoptions-=options  " 不保存全局选项（防止插件冲突）
set sessionoptions-=folds    " 不保存折叠状态
set sessionoptions-=blank    " 不保存空窗口
set sessionoptions+=tabpages,winsize,curdir

" 持久化 undo（目录由 Neovim XDG 默认管理）
set undofile

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set list listchars=tab:>-,trail:-,nbsp:␣
set wrap
set linebreak
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()
set foldtext=v:lua.vim.treesitter.foldtext()
set foldnestmax=3
set nofoldenable
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
set ignorecase
set smartcase
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set updatetime=300
set signcolumn=yes
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m
" NOTE: 仅支持 Linux/macOS，Windows 需自行配置 clipboard
set clipboard=unnamedplus
let mapleader=","
nnoremap <leader>bd :bd<CR>

" ============================================================================
" Plugin Configurations (VimL)
" ============================================================================

" navarasu/onedark.nvim — 配置见 lua << EOF 块
colorscheme onedark

" jistr/vim-nerdtree-tabs.git
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_open_on_new_tab = 1
nnoremap <silent> <leader>tn :NERDTreeTabsToggle<CR>

" scrooloose/nerdtree.git
let g:NERDTreeIgnore = ['^__pycache__$', 'Session.vim', '.DS_Store']

" catgoose/nvim-colorizer.lua — 配置见 lua << EOF 块

" folke/flash.nvim — 配置见 lua << EOF 块

" nvim-telescope/telescope.nvim — 键位配置在 lua << EOF 块

" gregorias/coerce.nvim（替代 vim-abolish 的 cr* coercion）— 配置在 lua << EOF 块
" 按 crs snake_case, crp PascalCase, crc camelCase, cru UPPER_CASE, crk kebab-case, crd dot.case

" kylechui/nvim-surround — 配置见 lua << EOF 块
" 用法: ys{motion}{char} 添加, ds{char} 删除, cs{旧}{新} 替换
"   ysiw) → (word)  ysiw( → ( word )  ds" → 删除引号  cs'" → ' 换成 "
"   ysiwf → function_name(word)  dst → 删除 HTML 标签

" NOTE: vim-unimpaired 已移除 — Nvim 0.11+ 内置: [b ]b [q ]q [l ]l [a ]a [f ]f [n ]n [d ]d
" [e/]e（交换行）和 [<Space>/]<Space>（插入空行）由内联 Lua 替代

" HiPhish/rainbow-delimiters.nvim — 配置在 lua << EOF 块

" tpope/vim-fugitive — 配置在 lua << EOF 块

" echasnovski/mini.align — 配置在 lua << EOF 块

" Wansmer/treesj（替代 splitjoin.vim）— 配置在 lua << EOF 块
" sj 展开为多行, sk 合并为单行

" mrjones2014/smart-splits.nvim（替代 vim-tmux-navigator）— 配置在 lua << EOF 块
" C-h/j/k/l 在 vim splits 和 tmux panes 间无缝导航

" lewis6991/gitsigns.nvim — 配置在 lua << EOF 块

" nvim-treesitter/nvim-treesitter-context — 键位配置在 lua << EOF 块

" zbirenbaum/copilot.lua（替代 copilot.vim）— 配置在 lua << EOF 块

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
inoremap <C-e> <End>  " NOTE: blink.cmp 补全菜单打开时 C-e 用于关闭菜单，关闭后回退到此映射
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
" LSP / Diagnostics / Formatting（VimScript 键位，Lua 配置在底部）
" ============================================================================

nmap <leader>rs <cmd>LspRestart<CR>
nnoremap <silent> to :Outline<CR>

" <space> 前缀键位（诊断面板 + 工作区符号搜索）
nnoremap <silent><nowait> <space>a <cmd>Trouble diagnostics toggle<cr>
nnoremap <silent><nowait> <space>s <cmd>Telescope lsp_workspace_symbols<cr>

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
require('mini.align').setup()

-- gregorias/coerce.nvim（替代 vim-abolish 的 cr* coercion）
-- Normal: cr + s/p/c/u/k/d  Visual/Motion: gcr + s/p/c/u/k/d
require('coerce').setup()

-- Wansmer/treesj（替代 splitjoin.vim）
local treesj = require('treesj')
treesj.setup({ use_default_keymaps = false })
vim.keymap.set('n', 'sj', treesj.split, { desc = 'Split to multi-line' })
vim.keymap.set('n', 'sk', treesj.join, { desc = 'Join to single line' })

-- mrjones2014/smart-splits.nvim（替代 vim-tmux-navigator）
-- tmux 自动检测，通过 @pane-is-vim 变量实现快速 pane 切换
require('smart-splits').setup()
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)

-- zbirenbaum/copilot.lua（通过 blink-copilot 集成到补全菜单）
require('copilot').setup({
  suggestion = { enabled = false },  -- 禁用 ghost text，由 blink 菜单显示
  panel = { enabled = false },
  filetypes = { ['*'] = true },
})

-- saghen/blink.cmp（替代 coc.nvim 补全）
require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>']     = { 'hide', 'fallback' },
    ['<CR>']      = { 'accept', 'fallback' },
    ['<Tab>']     = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>']   = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<C-n>']     = { 'select_next', 'fallback' },
    ['<C-p>']     = { 'select_prev', 'fallback' },
    ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    list = { selection = { preselect = true, auto_insert = false } },
    accept = { auto_brackets = { enabled = true } },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
    providers = {
      copilot = {
        name = 'copilot',
        module = 'blink-copilot',
        score_offset = 100,
        async = true,
      },
    },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})

-- windwp/nvim-autopairs（替代 coc-pairs）
require('nvim-autopairs').setup()

-- williamboman/mason.nvim + mason-lspconfig（LSP server 安装管理）
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'ruff', 'ts_ls', 'jsonls', 'yamlls', 'html' },
})

-- LSP server 配置（Neovim 0.11+ 原生 API，替代 coc.nvim）
-- nvim-lspconfig 作为数据包提供各 server 的默认 cmd/filetypes/root_markers
-- mason-lspconfig 自动对 ensure_installed 的 server 调用 vim.lsp.enable()
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.config('pyright', {
  settings = {
    pyright = { disableOrganizeImports = true },
    python = {
      analysis = {
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
          callArgumentNames = true,
          pytestParameters = true,
        },
      },
    },
  },
})

-- stevearc/conform.nvim（替代 coc-prettier + coc-ruff 格式化）
require('conform').setup({
  formatters_by_ft = {
    python     = { 'ruff_format', 'ruff_organize_imports' },
    javascript = { 'prettier', stop_after_first = true },
    typescript = { 'prettier', stop_after_first = true },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    html       = { 'prettier' },
    css        = { 'prettier' },
    json       = { 'prettier' },
    yaml       = { 'prettier' },
  },
})

-- folke/trouble.nvim（替代 CocList diagnostics）
require('trouble').setup({
  focus = true,
  auto_close = true,
})

-- LSP keymaps + autocmd（替代 coc.nvim VimScript 配置）
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- ruff: hover 由 pyright 处理，禁用 ruff 的 hover
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- 代码跳转（保持 coc 风格键位）
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', 'gr', vim.lsp.buf.references, 'Show references')
    map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')

    -- 诊断导航
    map('n', '[g', function() vim.diagnostic.jump({ count = -1 }) end, 'Previous diagnostic')
    map('n', ']g', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')

    -- 重命名 / code action / 格式化
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'x' }, '<leader>a', vim.lsp.buf.code_action, 'Code action')
    map('n', '<leader>qf', function()
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      vim.lsp.buf.code_action({ context = { only = { 'quickfix' }, diagnostics = vim.diagnostic.get(0, { lnum = lnum }) } })
    end, 'Quick fix')
    map({ 'n', 'x' }, '<leader>f', function()
      require('conform').format({ async = true, lsp_format = 'fallback' })
    end, 'Format')

    -- 光标停留时高亮当前符号及其引用（仅首个支持的 client 注册一次）
    if client and client:supports_method('textDocument/documentHighlight') and not vim.b[bufnr].lsp_highlight_attached then
      vim.b[bufnr].lsp_highlight_attached = true
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Inlay hints（Neovim 0.10+ 原生 API）
    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})

-- th: toggle inlay hints（全局）
vim.keymap.set('n', 'th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- :Format 命令（兼容旧习惯）
vim.api.nvim_create_user_command('Format', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, {})

-- 诊断显示配置
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN]  = '▲',
      [vim.diagnostic.severity.INFO]  = 'ℹ',
      [vim.diagnostic.severity.HINT]  = '➤',
    },
  },
  virtual_text = { spacing = 4 },
  float = { border = 'rounded' },
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
    globalstatus = true,    -- 所有分屏共用一个状态栏（Nvim 0.7+）
  },
  sections = {
    lualine_b = {
      { 'FugitiveHead', icon = '' },
      { 'diff', source = diff_source },
      'diagnostics',
    },
    lualine_c = {
      { 'filename', path = 1, symbols = { readonly = '[RO]', modified = '[+]' } },
      'filesize',
    },
    lualine_x = { 'fileformat', 'encoding', 'filetype' },
  },
  inactive_sections = {
    lualine_c = { { 'filename', path = 1 } },
  },
  tabline = {
    lualine_a = {
      { 'tabs', mode = 2, path = 0, max_length = vim.o.columns,
        fmt = function(name, context)
          -- 收集所有 tab 的文件名，找出重名的
          local dupes = {}
          for i = 1, vim.fn.tabpagenr('$') do
            local buflist = vim.fn.tabpagebuflist(i)
            local winnr = vim.fn.tabpagewinnr(i)
            local bufname = vim.fn.fnamemodify(vim.fn.bufname(buflist[winnr]), ':t')
            dupes[bufname] = (dupes[bufname] or 0) + 1
          end
          -- 当前 tab 的 buffer
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufname = vim.fn.bufname(buflist[winnr])
          local tail = vim.fn.fnamemodify(bufname, ':t')
          if dupes[tail] and dupes[tail] > 1 then
            -- 重名：追加父目录以区分
            local parent = vim.fn.fnamemodify(bufname, ':p:h:t')
            tail = parent .. '/' .. tail
          end
          return tail
        end,
      },
    },
  },
  extensions = { 'nerdtree', 'fugitive', 'quickfix' },
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
  options = {
    parsers = {
      names = { enable = false },
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

-- nvim-telescope/telescope.nvim
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = require("telescope.actions").select_tab_drop,
        ["<C-o>"] = require("telescope.actions").select_default,
      },
    },
  },
})

-- Telescope 全局键位
local builtin = require('telescope.builtin')
-- 搜索文件、内容、buffer 等
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fF', function() builtin.find_files({ hidden = true }) end, { desc = 'Find files (hidden)' })
vim.keymap.set('n', '<leader>fA', function() builtin.find_files({ hidden = true, no_ignore = true }) end, { desc = 'Find files (all)' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
-- Telescope LSP 集成
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'LSP references' })
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'LSP definitions' })
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { desc = 'LSP implementations' })
vim.keymap.set('n', '<leader>ft', builtin.lsp_type_definitions, { desc = 'LSP type definitions' })
vim.keymap.set('n', '<leader>fa', builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', 'tt', builtin.resume, { desc = 'Telescope resume' })

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
vim.g.matchup_matchparen_offscreen = { method = "popup" }
vim.g.matchup_matchparen_deferred = 1

-- nvim-treesitter-context
require('treesitter-context').setup({
  separator = "-",
})
vim.keymap.set('n', 'tc', '<cmd>TSContext toggle<cr>', { desc = 'Toggle treesitter context' })

-- tpope/vim-fugitive
-- 在 tree/blob buffer 中，.. 跳转到父目录；fugitive object buffer 关闭时自动删除
local fugitive_group = vim.api.nvim_create_augroup('FugitiveConfig', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = fugitive_group,
  pattern = { 'FugitiveTree', 'FugitiveBlob' },
  callback = function()
    vim.keymap.set('n', '..', '<cmd>edit %:h<CR>', { buffer = true })
  end,
})
vim.api.nvim_create_autocmd('User', {
  group = fugitive_group,
  pattern = 'FugitiveObject',
  callback = function()
    vim.bo.bufhidden = 'delete'
  end,
})

-- hedyhli/outline.nvim
local has_outline, outline = pcall(require, 'outline')
if has_outline then
  outline.setup({
    symbol_folding = {
      autofold_depth = false,
    },
    providers = {
      priority = { 'lsp', 'markdown', 'norg', 'man' },
    },
  })
end

EOF
