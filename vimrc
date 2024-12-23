set nocompatible              " be iMproved, required
filetype off                  " required


call plug#begin()

" appearance.vundle
Plug 'chrisbra/Colorizer'
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'

" git.vundle
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" project.vundle
" Plug 'preservim/nerdtree'
" Plug 'ryanoasis/vim-devicons'
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" search.vundle
Plug 'vim-scripts/IndexedSearch'
Plug 'nelstrom/vim-visual-star-search'
Plug 'Lokaltog/vim-easymotion'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'fannheyward/telescope-coc.nvim'

" textobjects.vundle
Plug 'coderifous/textobj-word-column.vim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'wellle/targets.vim'

" vim-improvements.vundle
Plug 'AndrewRadev/splitjoin.vim'
" Plug 'Raimondi/delimitMate'
" Plug 'briandoll/change-inside-surroundings.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tomtom/tcomment_vim'
Plug 'vim-scripts/matchit.zip'
"Plug 'mg979/vim-visual-multi'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-abolish'
"Plug 'tpope/vim-endwise'
"Plug 'tpope/vim-ragtag'
"Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
"Plug 'vim-scripts/AnsiEsc.vim'
Plug 'vim-scripts/lastpos.vim'
Plug 'goldfeld/ctrlr.vim'
Plug 'luochen1990/rainbow'
" Plug 'mhinz/vim-startify'
Plug 'tpope/vim-obsession'
Plug 'ojroques/vim-oscyank'

Plug 'github/copilot.vim'
" codeium, if auth ssl error, find ~/.vim/bundle/codeium.vim/autoload/codeium/command.vim and edit ```curl``` to ```curl -k```
" Plug 'Exafunction/codeium.vim'

" https://github.com/neoclide/coc.nvim
" 安装 node, 安装 nvm, nvm install 20, 设置 nvm alias default 20, npm install -g yarn
" cd ~/.vim/bundle/coc.nvim; yarn install --frozen-lockfile
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" in vim :CocInstall coc-calc coc-diagnostic coc-git coc-json coc-xml coc-yaml coc-pairs coc-prettier coc-lists
" in vim ondemand :CocInstall coc-pyright @yaegassy/coc-ruff coc-tsserver coc-solargraph coc-sh coc-docker @yaegassy/coc-nginx coc-sql coc-html @yaegassy/coc-tailwindcss3
" other common plugin: coc-java coc-perl coc-clangd coc-markdownlint

call plug#end()


" basic config
set t_Co=256
set number
set backspace=indent,eol,start
set history=1000
set showcmd
set showmode
set gcr=a:blinkon0
set visualbell
set autoread
set hidden
syntax on
set noswapfile
set nobackup
set nowb
"if has('persistent_undo')
"  if !isdirectory(expand('~').'/.vim/backups')
"    silent !mkdir ~/.vim/backups > /dev/null 2>&1
"  endif
"  set undodir=~/.vim/backups
"  set undofile
"endif
set undofile
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
filetype plugin on
filetype indent on
set list listchars=tab:>-,trail:-,nbsp:␣
set wrap
set linebreak
set foldmethod=indent
set foldnestmax=3
set nofoldenable
set wildmode=list:longest
set wildmenu
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
set incsearch
set hlsearch
set ignorecase
set smartcase
scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
command W w !sudo tee % > /dev/null
set cmdheight=1
set lazyredraw
set mouse=nv
set completeopt=menu,menuone,preview
set pastetoggle=<F7>
set grepprg=git\ grep
let g:grep_cmd_opts = '--line-number'
if has("win16") || has("win32") || has("win64")
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
let mapleader=","
map <leader>bd :bd<CR>

" plugin configs
" itchyny/lightline.vim
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'filesize', 'modified', 'cocstatus', 'currentfunction' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filesize': 'FileSize',
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction
function! FileSize()
    let l:size = getfsize(expand('%:p'))
    if l:size < 0
        return ''
    elseif l:size < 1024
        return l:size . 'B'
    elseif l:size < 1024*1024
        return printf('%.1fK', l:size / 1024.0)
    else
        return printf('%.1fM', l:size / 1024.0 / 1024.0)
    endif
endfunction
" oshdick/onedark.vim
colorscheme onedark
let g:onedark_hide_endofbuffer=1
let g:onedark_terminal_italics=1
" " jistr/vim-nerdtree-tabs.git
" let g:nerdtree_tabs_open_on_gui_startup = 0
" let g:nerdtree_tabs_focus_on_files = 1
" let g:nerdtree_tabs_open_on_new_tab = 1
" map <silent> <leader>tn :NERDTreeTabsToggle<CR>
" " scrooloose/nerdtree.git
" nnoremap <silent> <C-\> :NERDTreeFind<CR>
" let g:NERDTreeIgnore = ['^__pycache__$', 'Session.vim', '.DS_Store']
" chrisbra/color_highlight.git
let g:colorizer_auto_filetype='css,sass,less,html,htm,haml,erb'
" Lokaltog/vim-easymotion
let g:EasyMotion_keys='asdfjkoweriop'
nmap ,<ESC> ,,w
nmap ,<S-ESC> ,,b
" nvim-telescope/telescope.nvim
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fff <cmd>Telescope find_files<cr>
nnoremap <leader>ffh <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>ffi <cmd>Telescope find_files hidden=true no_ignore=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" tpope/vim-abolish
" Press crs (coerce to snake_case). MixedCase (crm), camelCase (crc), UPPER_CASE (cru), dash-case (cr-), and dot.case (cr.)
" tpope/vim-surround.git
let g:surround_113 = "#{\r}"   " v
let g:surround_35  = "#{\r}"   " #
let g:surround_45 = "<% \r %>"    " -
let g:surround_61 = "<%= \r %>"   " =
"ci', ca', cs'"
" tpope/vim-unimpaired “ 快速缩进
nmap < [
nmap > ]
omap < [
omap > ]
xmap < [
xmap > ]
" luochen1990/rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\  'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\  'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\  'operators': '_,_',
\  'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\  'separately': {
\    '*': {},
\    'tex': {
\      'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\    },
\    'lisp': {
\      'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\    },
\    'vim': {
\      'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\    },
\    'html': {
\      'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\    },
\    'css': 0,
\    'nerdtree': 0,
\  }
\}
" mhinz/vim-startify
let g:startify_change_to_dir = 0
" let g:startify_change_to_vcs_root = 0
" tomtom/tcomment_vim.git
nmap <silent> gcp <c-_>p
let g:tcomment_textobject_inlinecomment = ''
" tpope/vim-fugitive
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete
" junegunn/vim-easy-align
vmap <Leader>e <Plug>(EasyAlign)
nmap <Leader>e <Plug>(EasyAlign)
if !exists('g:easy_align_delimiters')
  let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
" AndrewRadev/splitjoin.vim
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>
" christoomey/vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
" skwp/YankRing.vim
let g:yankring_history_file = '.yankring-history'
nnoremap ,yr :YRShow<CR>
nnoremap C-y :YRShow<CR>
" airblade/vim-gitgutter
nnoremap <silent> <leader>tg :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0

" customize configs
vnoremap <leader>p "0p
vnoremap <leader>P "0P
nnoremap 0 ^
nnoremap ^ 0
map ,# ysiw#
vmap ,# c#{<C-R>"}<ESC>
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
imap <C-a> <esc>wa
inoremap <C-a> <C-O><S-i>
inoremap <C-e> <End>
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
" function! OpenNerdTree()
"   if &modifiable && strlen(expand('%')) > 0 && !&diff
"     NERDTreeFind
"   else
"     NERDTreeToggle
"   endif
" endfunction
" nnoremap <silent> <C-\> :call OpenNerdTree()<CR>
nmap <silent> ,qc :cclose<CR>
nmap <silent> ,qo :copen<CR>
nnoremap <C-w>f :sp +e<cfile><CR>
nnoremap <C-w>gf :tabe<cfile><CR>
map <silent> ,gz <C-w>o
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>
nnoremap <silent> ,cr :let @* = expand("%")<CR>
nnoremap <silent> ,cn :let @* = expand("%:t")<CR>
nmap <silent> // :nohlsearch<CR>
nnoremap ' `
nnoremap ` '
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
nnoremap <silent> <leader>9 9gt
nnoremap <silent> <leader>0 :tablast<CR>
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
nmap <leader>rd :redraw!<CR>
nnoremap <F8> :set wrap! wrap?<CR>
imap <F8> <C-O><F8>
nnoremap <silent> <C-x> :cn<CR>
nnoremap <silent> <C-z> :cp<CR>
cmap w!! w !sudo tee % >/dev/null
" no use, just for lookup...
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-
nnoremap <C-Left> <C-w><
nnoremap <C-Right>  <C-w>>
" show invisible chars
highlight nonascii guibg=Red ctermbg=2
autocmd BufReadPost * syntax match nonascii "[^\u0000-\u007F]"

" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,cs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,cl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap ,c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap ,cs :let @*=expand("%")<CR>
  nmap ,cl :let @*=expand("%:p")<CR>
endif

nnoremap <leader>r :!"%:p"

" neoclide/coc.nvim begin
nmap <leader>rs :CocRestart<CR>
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Search files in workspace
nnoremap <silent><nowait> <space>f  :<C-u>CocList files<cr>
" Do default action for next item
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
nnoremap <silent> to :call CocAction('showOutline')<CR>

" compatible with easymotion
autocmd User EasyMotionPromptBegin :let b:coc_diagnostic_disable = 1
autocmd User EasyMotionPromptEnd :let b:coc_diagnostic_disable = 0

" toggle pyright inlay hints
function! TogglePyrightInlayVariableHints()
    " Check if we are in a Python file
    if &filetype == 'python'
        " We will force toggle by tracking the state using a global variable
        if !exists('g:pyright_inlayVariableHints_state')
            let g:pyright_inlayVariableHints_state = v:false
        endif

        " Toggle the state
        let g:pyright_inlayVariableHints_state = !g:pyright_inlayVariableHints_state

        " Set the new value explicitly based on the toggled state
        let new_value = g:pyright_inlayVariableHints_state

        " Update the setting dynamically
        call CocAction('updateConfig', 'pyright.inlayHints.variableTypes', new_value)

        " Notify the user
        echo 'pyright.inlayHints.variableTypes set to ' . (new_value ? 'enabled' : 'disabled')
    else
        echo 'Not a Python file. Toggle aborted.'
    endif
endfunction

" toggle pyright inlay hints
function! TogglePyrightInlayParameterHints()
    " Check if we are in a Python file
    if &filetype == 'python'
        " We will force toggle by tracking the state using a global variable
        if !exists('g:pyright_inlayParameterHints_state')
            let g:pyright_inlayParameterHints_state = v:false
        endif

        " Toggle the state
        let g:pyright_inlayParameterHints_state = !g:pyright_inlayParameterHints_state

        " Set the new value explicitly based on the toggled state
        let new_value = g:pyright_inlayParameterHints_state

        " Update the setting dynamically
        call CocAction('updateConfig', 'pyright.inlayHints.parameterTypes', new_value)

        " Notify the user
        echo 'pyright.inlayHints.parameterTypes set to ' . (new_value ? 'enabled' : 'disabled')
    else
        echo 'Not a Python file. Toggle aborted.'
    endif
endfunction

" Create a command to toggle it
command! TogglePyrightInlayVariableHints call TogglePyrightInlayVariableHints()
command! TogglePyrightInlayParameterHints call TogglePyrightInlayParameterHints()
let g:pyright_inlayVariableHints_state = v:true
nnoremap <silent> tv :call TogglePyrightInlayVariableHints()<CR>
nnoremap <silent> tp :call TogglePyrightInlayParameterHints()<CR>

" neoclide/coc.nvim end

" ojroques/vim-oscyank
nmap <leader>y <Plug>OSCYankOperator
vmap <leader>y <Plug>OSCYankVisual

" copilot
let g:copilot_enabled = 1
" let g:copilot_tab_fallback = ""
" let g:copilot_assume_mapped = 1
inoremap <C-e> <Plug>(copilot-next)
inoremap <Leader>n <Plug>(copilot-next)
inoremap <Leader>p <Plug>(copilot-prev)
inoremap <leader>a <Plug>(copilot-accept)

" Codeium
" let g:codeium_enabled = v:true
" imap <script><silent><nowait><expr> <C-g> codeium#Accept()
" imap <C-e>   <Cmd>call codeium#CycleCompletions(1)<CR>
" imap <Leader>n   <Cmd>call codeium#CycleCompletions(1)<CR>
" imap <C-x>   <Cmd>call codeium#Clear()<CR>

" fannheyward/telescope-coc.nvim
" :Telescope coc to get subcommands
nnoremap <leader>fr <cmd>Telescope coc references<cr>
nnoremap <leader>fd <cmd>Telescope coc definitions<cr>
nnoremap <leader>fc <cmd>Telescope coc declarations<cr>
nnoremap <leader>fi <cmd>Telescope coc implementations<cr>
nnoremap <leader>ft <cmd>Telescope coc type_definitions<cr>
nnoremap <leader>fa <cmd>Telescope coc diagnostics<cr>
nnoremap <silent> tt :Telescope resume<cr>

" tpope/vim-obsession
let session_file = getcwd() . "/Session.vim"
" if empty($VIM_NO_SESSION) && session_file !~ "/tmp/Session.vim"
if empty($VIM_NO_SESSION) && session_file =~ "workspace"
  set sessionoptions-=blank,buffers
  if filereadable(session_file)
      execute 'silent! source ' . session_file
  else
      execute 'mksession! ' . session_file
  endif
endif

"luochen1990/rainbow'
autocmd VimEnter * RainbowToggleOn
autocmd TabEnter * RainbowToggleOn

function! ToggleCocExtension(extension)
    " 使用 CocAction toggleExtension 来切换插件状态
    call CocAction('toggleExtension', a:extension)

    " 获取插件的状态信息
    let l:status = CocAction('extensionStats')

    " 遍历插件状态列表，查找指定插件
    let l:found = 0
    for ext in l:status
        if has_key(ext, 'id') && ext.id ==# a:extension
            let l:found = 1
            if ext.state ==# 'activated'
                echo a:extension . " is now enabled"
            else
                echo a:extension . " is now disabled"
            endif
            break
        endif
    endfor

    " 如果没有找到插件，输出错误信息
    if l:found == 0
        echo "Extension " . a:extension . " not found."
    endif
endfunction
nnoremap <silent> tr :call ToggleCocExtension('@yaegassy/coc-ruff')<CR>


" fannheyward/telescope-coc.nvim
lua << EOF
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
        prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
    }
  },
})
require('telescope').load_extension('coc')
EOF

" nvim-tree/nvim-tree
lua << EOF
vim.keymap.set('n', '<leader>tn', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-\\>', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  git = {
    enable = true, -- 启用 Git 集成
    ignore = false, -- 显示被 Git 忽略的文件
  },
  sort_by = "case_sensitive", -- 文件排序规则，可选
  view = {
    width = 30, -- 窗口宽度
    side = "left", -- 显示在左侧
  },
  renderer = {
    group_empty = true, -- 空文件夹显示成分组
    highlight_git = true, -- 高亮 Git 状态
    icons = {
      show = {
        git = true, -- 显示 Git 图标
        folder = true,
        file = true,
      },
    },
  },
  filters = {
    dotfiles = true, -- 隐藏 . 开头的文件
    custom = { "^__pycache__$", "Session.vim", ".DS_Store" },
  },
  actions = {
    open_file = {
      resize_window = true, -- 打开文件时调整窗口大小
    },
  },
  diagnostics = {
    enable = true, -- 启用诊断显示
    show_on_dirs = true, -- 显示目录中的诊断信息
    icons = {
      hint = "", -- 提示图标
      info = "", -- 信息图标
      warning = "", -- 警告图标
      error = "", -- 错误图标
    },
  },
})
EOF

" lukas-reineke/indent-blankline.nvim
lua << EOF
require("ibl").setup()
EOF
