" ============================================================================
" Pre-plugin Settings
" ============================================================================
" NOTE: VimL map/nnoremap/vnoremap 等映射命令不支持行尾 " 注释（会被当作
" 映射内容的一部分）。为保持一致性，本文件所有注释统一放在上一行。

" Python 缩进修复：默认 shiftwidth()*2 导致 { 后缩进 8 格
" NOTE: treesitter indent 启用时优先用 treesitter，此为 fallback
" 参考: https://github.com/vim/vim/blob/master/runtime/autoload/python.vim
let g:python_indent = { 'open_paren': 'shiftwidth()' }

" ============================================================================
" Plugins (vim-plug)
" ============================================================================

call plug#begin()

" --- appearance ---
" 主题
Plug 'navarasu/onedark.nvim'
" 状态栏
Plug 'nvim-lualine/lualine.nvim'
" 文件类型图标（Lua 插件通用依赖）
Plug 'nvim-tree/nvim-web-devicons'
" CSS/Hex 颜色值实时预览
Plug 'catgoose/nvim-colorizer.lua'
" 文件类型图标（VimL 版，仅供 NERDTree 使用；迁移 nvim-tree 时删除）
Plug 'ryanoasis/vim-devicons'
" 缩进参考线
Plug 'lukas-reineke/indent-blankline.nvim'
" 彩虹括号（匹配括号不同颜色）
Plug 'HiPhish/rainbow-delimiters.nvim'

" --- treesitter ---
" NOTE: main 分支需要 tree-sitter-cli (>= 0.26.1) 才能 :TSInstall/:TSUpdate
"   macOS: brew install tree-sitter-cli
"   Ubuntu: sudo apt install tree-sitter-cli  (24.04+, check version >= 0.26.1)
" 语法高亮 / 代码结构解析
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" 顶部固定显示当前函数/类上下文
Plug 'nvim-treesitter/nvim-treesitter-context'
" treesitter 文本对象查询文件（mini.ai 依赖）
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" --- git ---
" Git 命令集成（:Git blame/diff/log 等）
Plug 'tpope/vim-fugitive'
" 行级 git diff 标记 + hunk 操作
Plug 'lewis6991/gitsigns.nvim'

" --- navigation ---
" 文件树侧栏
Plug 'preservim/nerdtree'
" NERDTree 多 tab 同步
Plug 'chenmi319/vim-nerdtree-tabs'
" LSP 符号大纲面板
Plug 'hedyhli/outline.nvim'
" Lua 异步工具库（telescope 等插件的依赖）
Plug 'nvim-lua/plenary.nvim'
" 模糊搜索（文件/内容/buffer/LSP 符号等）
Plug 'nvim-telescope/telescope.nvim'
" 诊断/引用/quickfix 列表面板
Plug 'folke/trouble.nvim'
" 快速跳转（增强 f/t/s，替代 easymotion/hop）
Plug 'folke/flash.nvim'

" --- editing ---
" 括号/引号包裹操作（ys/ds/cs）
Plug 'kylechui/nvim-surround'
" 命名风格转换（crs snake_case, crc camelCase 等）
Plug 'gregorias/coop.nvim'
Plug 'gregorias/coerce.nvim'
" 代码块展开/合并（sj 展开, sk 合并）
Plug 'Wansmer/treesj'
" 文本对齐（ga 触发）
Plug 'echasnovski/mini.align'
" 增强 % 匹配（支持 if/else/end 等语言结构）
Plug 'andymass/vim-matchup'
" 增强文本对象（函数参数 ia/aa, 条件 ii/ai 等，基于 treesitter）
Plug 'echasnovski/mini.ai'

" --- session ---
" 自动保存/恢复会话（按工作目录）
Plug 'rmagatti/auto-session'

" --- tmux 集成 ---
" C-h/j/k/l 在 vim splits 和 tmux panes 间无缝导航 + 窗口 resize
Plug 'mrjones2014/smart-splits.nvim'

" --- filetype ---
" Markdown 渲染增强（表格/代码块/标题等美化显示）
Plug 'MeanderingProgrammer/render-markdown.nvim'

" --- ai ---
" GitHub Copilot（Lua 版，替代 copilot.vim）
Plug 'zbirenbaum/copilot.lua'

" --- lsp / completion ---
" LSP 客户端配置框架
Plug 'neovim/nvim-lspconfig'
" LSP server 自动安装管理
Plug 'williamboman/mason.nvim'
" mason + lspconfig 桥接（自动配置已安装的 server）
Plug 'mason-org/mason-lspconfig.nvim'
" 补全引擎（替代 nvim-cmp，更快）
Plug 'saghen/blink.cmp', { 'tag': 'v1.*' }
" 通用代码片段集合
Plug 'rafamadriz/friendly-snippets'
" blink.cmp 的 Copilot 补全源
Plug 'fang2hou/blink-copilot'
" 代码格式化框架（替代 null-ls/none-ls 的 formatting 部分）
Plug 'stevearc/conform.nvim'
" 自动补全括号/引号
Plug 'windwp/nvim-autopairs'

call plug#end()

" ============================================================================
" General Settings
" ============================================================================

" 显示行号 + 相对行号（方便 5j/3k 计数跳转）
set number
set relativenumber
" 高亮当前行
set cursorline
" 不显示模式（lualine 已显示）
set noshowmode
" 光标不闪烁
set guicursor=a:blinkon0
" 新分屏在下方/右方打开，更符合阅读直觉
set splitbelow
set splitright
" 全局状态栏（多窗口只显示一条 lualine）
set laststatus=3
" 原生补全菜单最多 15 行（blink.cmp 用自己的浮窗，此项影响原生补全）
set pumheight=15
" :s/foo/bar 实时预览替换效果，split 窗口显示屏幕外匹配
set inccommand=split
" 折行时保持缩进对齐（配合 wrap + linebreak）
set breakindent
" 关闭未保存 buffer 时弹确认而非报错
set confirm
" visual block 模式可超出行尾选择（编辑表格/对齐时实用）
set virtualedit=block
" 去掉文件末尾空行的 ~ 标记；diff 删除区域用斜线填充
set fillchars=eob:\ ,diff:╱

" 会话选项 - 控制 session 保存/恢复的内容
" 不保存全局选项（防止插件冲突）、折叠状态、空窗口
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=blank

" 持久化 undo（目录由 Neovim XDG 默认管理）
set undofile

" 缩进：2 空格，>/<缩进对齐到 shiftwidth 倍数
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set shiftround

" 不可见字符显示
set list listchars=tab:>-,trail:-,nbsp:␣

" 换行与折行
" 长行自动折行显示，在单词边界折行不截断
set wrap
set linebreak

" 折叠：使用 treesitter 表达式
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()
set foldtext=v:lua.vim.treesitter.foldtext()
" 打开文件时全部展开，手动 zc 折叠不会被意外重置
set foldlevel=99

" 补全菜单忽略的文件模式
set wildignore=*.o,*.obj,*~
set wildignore+=*DS_Store*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" 滚动留白：上下 8 行，左右 15 列
set scrolloff=8
set sidescrolloff=15

" 搜索：忽略大小写，含大写时自动区分
set ignorecase
set smartcase

" 编码：自动检测顺序
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" CursorHold 延迟（ms），影响诊断和高亮刷新
set updatetime=300
" 始终显示符号列，避免内容跳动
set signcolumn=yes

" 外部搜索命令
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m

" NOTE: 仅支持 Linux/macOS，Windows 需自行配置 clipboard
" 系统剪贴板
set clipboard=unnamedplus

" Leader 键
let mapleader=","

" ============================================================================
" Plugin Configurations (VimL)
" ============================================================================

" navarasu/onedark.nvim — Lua 配置在 lua << EOF 块
colorscheme onedark

" --- NERDTree + vim-nerdtree-tabs（文件树）
" 启动时不自动打开；打开文件后焦点回到文件窗口；新 tab 自动显示
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_open_on_new_tab = 1
let g:NERDTreeIgnore = ['^__pycache__$', '\.pyc$', 'Session.vim', '.DS_Store', '^node_modules$', '\.git$', '\.cache$']
" 显示隐藏文件；精简界面（去掉顶部帮助提示）
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1

" <leader>tn: 在所有 tab 中同步切换 NERDTree
nnoremap <silent> <leader>tn :NERDTreeTabsToggle<CR>

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

" ============================================================================
" Custom Keybindings
" ============================================================================
" NOTE: [e/]e（交换行）和 [<Space>/]<Space>（插入空行）由内联 Lua 替代

" --- 导航 / 光标移动
" 0/^: 交换，0 跳到首个非空字符，^ 跳到行首
nnoremap 0 ^
nnoremap ^ 0
" j/k: 按屏幕行移动（长行折行时更直观）
nnoremap j gj
nnoremap k gk
" ,.: 跳到上次编辑位置
nnoremap ,. '.

" --- 粘贴 / 寄存器
" ,p/,P: visual 模式从 yank 寄存器粘贴（不被 d/x 覆盖）
vnoremap <leader>p "0p
vnoremap <leader>P "0P
" ,Y: 复制整个文件到系统剪贴板
nnoremap <leader>Y :%y+<CR>

" --- 搜索 / 标记
" //: 取消搜索高亮
nnoremap <silent> // :nohlsearch<CR>
" '/`: 交换，' 跳到精确位置（行+列），` 跳到行
nnoremap ' `
nnoremap ` '

" --- 窗口 / 分屏
" ,qc/,qo: 关闭/打开 quickfix 窗口
nnoremap <silent> ,qc :cclose<CR>
nnoremap <silent> ,qo :copen<CR>
" C-w f/gf: 分屏/新tab打开光标下文件路径
nnoremap <C-w>f :sp +e<cfile><CR>
nnoremap <C-w>gf :tabe<cfile><CR>
" ,gz: 关闭其他所有窗口（仅保留当前）
nnoremap <silent> ,gz <C-w>o

" --- Tab 管理
" ,tc: 新建 tab, ,tx: 关闭 tab
nnoremap <leader>tc :tabnew<CR>
nnoremap <leader>tx :tabclose<CR>
" ,t]/,t[: 向右/左移动当前 tab 位置
nnoremap <silent> <leader>t] :tabmove +1<CR>
nnoremap <silent> <leader>t[ :tabmove -1<CR>
" H/L: 前/后一个 tab
nnoremap <silent> H :tabprevious<CR>
nnoremap <silent> L :tabnext<CR>
" Option+h/l (macOS): 前/后一个 tab
nnoremap ˙ gT
nnoremap ¬ gt
let g:lasttab = 1
" T: 切换到上次访问的 tab
nnoremap <silent> T :exe "tabn ".g:lasttab<CR>
augroup LastTab
  autocmd!
  autocmd TabLeave * let g:lasttab = tabpagenr()
augroup END
" ,1-9: 按编号切换 tab, ,0: 最后一个 tab
for i in range(1, 9)
  exe 'nnoremap <silent> <leader>' . i . ' ' . i . 'gt'
endfor
nnoremap <silent> <leader>0 :tablast<CR>

" --- 文件操作
" ,bd: 关闭当前 buffer  ,ww: 保存  ,xx: 保存并退出  ,qq: 退出所有
nnoremap <leader>bd :bd<CR>
nnoremap <leader>ww :w<CR>
nnoremap <leader>xx :x<CR>
nnoremap <leader>qq :qa<CR>

" --- 路径复制（,c 前缀: f=从~开始, r=相对, n=文件名, s=短/相对, l=长/绝对）
" NOTE: ,cr 和 ,cs 在 normal 模式下功能相同（都是相对路径），保留冗余方便记忆
" ,cf: 复制路径（~/开头）  ,cr/,cs: 相对路径  ,cn: 文件名  ,cl: 绝对路径
nnoremap <silent> ,cf :let @+ = expand("%:~")<CR>
nnoremap <silent> ,cr :let @+ = expand("%")<CR>
nnoremap <silent> ,cn :let @+ = expand("%:t")<CR>
nnoremap <silent> ,cs :let @+ = expand("%")<CR>
nnoremap <silent> ,cl :let @+ = expand("%:p")<CR>
" visual: 复制路径:行号范围 + 选中内容 (s=short/相对, l=long/绝对)
xnoremap <silent> ,cs :<C-u>let @+ = expand("%") . ":" . line("'<") . "-" . line("'>") . "\n" . join(getline(line("'<"), line("'>")), "\n")<CR>
xnoremap <silent> ,cl :<C-u>let @+ = expand("%:p") . ":" . line("'<") . "-" . line("'>") . "\n" . join(getline(line("'<"), line("'>")), "\n")<CR>

" --- 可视模式 / 杂项
" </> 缩进后保持选区
vnoremap < <gv
vnoremap > >gv
" F8: 切换 wrap
nnoremap <F8> :set wrap! wrap?<CR>
inoremap <F8> <C-O>:set wrap! wrap?<CR>
" 高亮非 ASCII 字符（按需手动执行）
command! NonASCIIHighlight exec 'syntax match nonascii "[^\u0000-\u007F]"' | hi nonascii ctermbg=2 guibg=Red

" ============================================================================
" Lua Plugin Configurations
" ============================================================================

lua << EOF

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 1. Bootstrap                                                         ║
-- ╚════════════════════════════════════════════════════════════════════════╝

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

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 2. Appearance                                                        ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- navarasu/onedark.nvim — One Dark 主题
require('onedark').setup({
  highlights = {
    IblScope = { fg = '$grey', fmt = 'nocombine' },  -- scope 线: 用灰色替代默认紫色
  },
})
require('onedark').load()

-- nvim-tree/nvim-web-devicons — 文件类型图标
require('nvim-web-devicons').setup()

-- catgoose/nvim-colorizer.lua — 颜色代码实时高亮预览
require('colorizer').setup({
  options = {
    parsers = {
      names = { enable = false },  -- 不高亮颜色名称（如 "red"），只高亮 hex/rgb
    },
  },
})

-- lukas-reineke/indent-blankline.nvim — 缩进线
require("ibl").setup()

-- HiPhish/rainbow-delimiters.nvim — 彩虹括号：零配置，默认设置即可

-- nvim-lualine/lualine.nvim — 状态栏（替代 lightline.vim）
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
      { 'FugitiveHead', icon = '' },  -- git 分支名
      { 'diff', source = diff_source },       -- git diff 统计（来自 gitsigns）
      'diagnostics',                           -- LSP 诊断计数
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

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 3. Treesitter                                                        ║
-- ╚════════════════════════════════════════════════════════════════════════╝

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

-- nvim-treesitter-context — 顶部固定显示当前函数/类上下文
require('treesitter-context').setup({
  separator = "-",
})
-- tc: 切换 treesitter context 显示
vim.keymap.set('n', 'tc', '<cmd>TSContext toggle<cr>', { desc = 'Toggle treesitter context' })

-- vim-matchup — 增强 % 匹配（treesitter 集成）
vim.g.matchup_matchparen_offscreen = { method = "popup" }  -- 匹配括号在屏幕外时弹窗显示
vim.g.matchup_matchparen_deferred = 1                      -- 延迟匹配，减少卡顿

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 4. Editing                                                           ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- kylechui/nvim-surround（替代 vim-surround）
-- 用法: ys{motion}{char} 添加, ds{char} 删除, cs{旧}{新} 替换
--   ysiw) → (word)  ysiw( → ( word )  ds" → 删除引号  cs'" → ' 换成 "
--   ysiwf → function_name(word)  dst → 删除 HTML 标签
require('nvim-surround').setup()

-- echasnovski/mini.ai（替代 targets.vim）
-- 内置 text objects: a( a[ a{ a< a" a' a` aq(任意引号) ab(任意括号) af(函数调用) aa(参数) at(标签)
-- 增强: 光标不在目标内时自动 seek forward (search_method = 'cover_or_next')
-- treesitter text objects: F=函数定义 o=条件/循环 c=类
local ts_spec = require('mini.ai').gen_spec.treesitter
require('mini.ai').setup({
  n_lines = 100,
  custom_textobjects = {
    F = ts_spec({ a = '@function.outer', i = '@function.inner' }),
    o = ts_spec({ a = { '@conditional.outer', '@loop.outer' }, i = { '@conditional.inner', '@loop.inner' } }),
    c = ts_spec({ a = '@class.outer', i = '@class.inner' }),
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
-- crs=snake_case crp=PascalCase crc=camelCase cru=UPPER_CASE crk=kebab-case crd=dot.case
require('coerce').setup()

-- Wansmer/treesj（替代 splitjoin.vim）
local treesj = require('treesj')
treesj.setup({ use_default_keymaps = false })
vim.keymap.set('n', 'sj', treesj.split, { desc = 'Split to multi-line' })   -- sj: 展开为多行
vim.keymap.set('n', 'sk', treesj.join, { desc = 'Join to single line' })    -- sk: 合并为单行

-- windwp/nvim-autopairs — 自动补全括号/引号（替代 coc-pairs）
require('nvim-autopairs').setup()

-- folke/flash.nvim — 快速跳转（替代 vim-easymotion）
-- labels 复用原 EasyMotion_keys
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

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 5. Navigation                                                        ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- nvim-telescope/telescope.nvim — 模糊搜索
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = require("telescope.actions").select_tab_drop,  -- 回车在新 tab 打开（若已有则跳转）
        ["<C-o>"] = require("telescope.actions").select_default,  -- C-o 在当前窗口打开
      },
    },
  },
})

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

-- mrjones2014/smart-splits.nvim（替代 vim-tmux-navigator）
-- tmux 自动检测，通过 @pane-is-vim 变量实现快速 pane 切换
require('smart-splits').setup()
-- C-h/j/k/l: 在 vim splits 和 tmux panes 间无缝导航
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = 'Move to left split/pane' })
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = 'Move to below split/pane' })
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = 'Move to above split/pane' })
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = 'Move to right split/pane' })

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 6. Git                                                               ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- tpope/vim-fugitive — Git 命令集成
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

-- lewis6991/gitsigns.nvim — Git 行状态标记
require('gitsigns').setup({
  -- 用半块色块替代默认细线，更醒目
  signs = {
    add          = { text = '▌' },
    change       = { text = '▌' },
    delete       = { text = '▁' },
    topdelete    = { text = '▔' },
    changedelete = { text = '▋' },
    untracked    = { text = '┆' },
  },
  -- staged 同样字符，靠颜色区分
  signs_staged = {
    add          = { text = '▌' },
    change       = { text = '▌' },
    delete       = { text = '▁' },
    topdelete    = { text = '▔' },
    changedelete = { text = '▋' },
    untracked    = { text = '┆' },
  },
  -- 行号也跟着变色，双重提示
  numhl = true,
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
    end, { desc = 'Next hunk' })
    map('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal({'[c', bang = true})
      else gs.nav_hunk('prev') end
    end, { desc = 'Previous hunk' })

    -- ]C / [C: 跳到下/上一个已暂存 (staged) 的修改块
    map('n', ']C', function() gs.nav_hunk('next', { target = 'staged' }) end, { desc = 'Next staged hunk' })
    map('n', '[C', function() gs.nav_hunk('prev', { target = 'staged' }) end, { desc = 'Previous staged hunk' })

    map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })           -- ,hp: 弹窗预览当前 hunk 的 diff
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Blame line (full)' })  -- ,hb: 显示当前行完整 blame 信息
    map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this (index)' })           -- ,hd: 分屏 diff 当前文件（与 index 对比）
    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff this (prev commit)' })  -- ,hD: 分屏 diff（与上一个 commit 对比）

    map('n', '<leader>th', gs.toggle_linehl, { desc = 'Toggle hunk highlight' })           -- ,th: toggle 修改行高亮
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle inline blame' }) -- ,tb: toggle 行尾 inline blame

    -- ih: text object 选中当前 hunk，如 vih 选中、yih 复制、dih 删除
    map({'o', 'x'}, 'ih', gs.select_hunk, { desc = 'Select hunk' })
  end
})

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 7. Search                                                            ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- 可视模式 * 和 # 搜索选中文本（替代 vim-visual-star-search）
vim.keymap.set('x', '*', function()
  vim.cmd('normal! "vy')
  local search = vim.fn.escape(vim.fn.getreg('v'), '/\\')
  vim.fn.setreg('/', '\\V' .. search)
  vim.cmd('normal! n')
end, { desc = 'Search selection forward' })
vim.keymap.set('x', '#', function()
  vim.cmd('normal! "vy')
  local search = vim.fn.escape(vim.fn.getreg('v'), '?\\')
  vim.fn.setreg('/', '\\V' .. search)
  vim.cmd('normal! N')
end, { desc = 'Search selection backward' })

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 8. Completion                                                        ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- zbirenbaum/copilot.lua — AI 补全（通过 blink-copilot 集成到补全菜单）
require('copilot').setup({
  suggestion = { enabled = false },  -- 禁用 ghost text，由 blink 菜单显示
  panel = { enabled = false },
  filetypes = { ['*'] = true },
})

-- saghen/blink.cmp — 补全引擎（替代 coc.nvim 补全）
require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },  -- 手动触发补全/切换文档
    ['<C-e>']     = { 'hide', 'fallback' },       -- 关闭补全菜单
    ['<CR>']      = { 'accept', 'fallback' },      -- 确认选中项
    ['<Tab>']     = { 'select_next', 'snippet_forward', 'fallback' },  -- 下一项 / snippet 下一占位
    ['<S-Tab>']   = { 'select_prev', 'snippet_backward', 'fallback' }, -- 上一项 / snippet 上一占位
    ['<C-n>']     = { 'select_next', 'fallback' }, -- 下一项
    ['<C-p>']     = { 'select_prev', 'fallback' }, -- 上一项
    ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },  -- 向上滚动文档
    ['<C-f>']     = { 'scroll_documentation_down', 'fallback' }, -- 向下滚动文档
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },  -- 自动显示文档
    list = { selection = { preselect = true, auto_insert = false } }, -- 预选但不自动插入
    accept = { auto_brackets = { enabled = true } },                 -- 自动补括号
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
    providers = {
      copilot = {
        name = 'copilot',
        module = 'blink-copilot',
        score_offset = 100,  -- 提高 copilot 建议优先级
        async = true,
      },
    },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 9. LSP                                                               ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- williamboman/mason.nvim + mason-lspconfig — LSP server 安装管理
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
    pyright = { disableOrganizeImports = true },  -- ruff 处理 import 排序
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

-- stevearc/conform.nvim — 格式化（替代 coc-prettier + coc-ruff）
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

-- folke/trouble.nvim — 诊断面板（替代 CocList diagnostics）
require('trouble').setup({
  focus = true,       -- 打开时自动聚焦到 Trouble 窗口
  auto_close = true,  -- 列表为空时自动关闭
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

    -- 代码跳转 — K, grr, gri, gra, grt, gO, [d/]d 由 Neovim 0.11+ 内置
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')

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
  virtual_text = { spacing = 4 },  -- 行尾诊断信息间距
  float = { border = 'rounded' },  -- 浮窗圆角边框
})

-- LSP / Diagnostics 全局键位
vim.keymap.set('n', 'th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })                                             -- th: 切换 inlay hints
vim.keymap.set('n', '<leader>rs', '<cmd>LspRestart<CR>', { desc = 'Restart LSP' })  -- ,rs: 重启 LSP server
vim.keymap.set('n', 'to', '<cmd>Outline<CR>', { desc = 'Toggle Outline' })          -- to: 切换 Outline 面板
vim.keymap.set('n', '<space>a', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Trouble diagnostics' })     -- Space+a: 诊断面板
vim.keymap.set('n', '<space>s', '<cmd>Telescope lsp_workspace_symbols<cr>', { desc = 'Workspace symbols' })  -- Space+s: 工作区符号搜索

-- :Format 命令（兼容旧习惯）
vim.api.nvim_create_user_command('Format', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, {})

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 10. Session                                                          ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- rmagatti/auto-session — 自动保存/恢复编辑会话
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

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 11. Outline                                                          ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- hedyhli/outline.nvim — 代码大纲/符号面板
local has_outline, outline = pcall(require, 'outline')
if has_outline then
  outline.setup({
    symbol_folding = {
      autofold_depth = false,  -- 不自动折叠符号
    },
    providers = {
      priority = { 'lsp', 'markdown', 'norg', 'man' },  -- LSP 优先
    },
  })
end

-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║ 12. Utility                                                          ║
-- ╚════════════════════════════════════════════════════════════════════════╝

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

EOF
