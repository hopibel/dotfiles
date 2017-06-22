" vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'christoomey/vim-tmux-navigator'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'ajh17/VimCompletesMe'
Plug 'neomake/neomake'
Plug 'jamessan/vim-gnupg'
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jwalton512/vim-blade'
Plug 'leafgarland/typescript-vim'
Plug 'zchee/deoplete-jedi'
Plug 'keith/swift.vim'
Plug 'hopibel/taskpaper.vim'

call plug#end()

" allow project-specific vim configuration in .exrc files
set exrc
set secure

" jump to last known position after opening except in git commit messages
autocmd BufReadPost *
	\ if &ft != 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
	\ 	exe "normal! g`\"" |
	\ endif

" password file options
augroup PasswordManager
	autocmd BufEnter pass.gpg call SetPassOptions()
	autocmd CursorHold,BufUnload pass.gpg call ClearClipboard()
augroup END

function! SetPassOptions()
	set updatetime=60000
	let color = synIDattr(hlID('CursorLine'), 'bg')
	syntax match Password "\v(.+\n)@<=(.+)@>\n^$"
	highlight Password ctermbg=red ctermfg=red guibg=red guifg=red
	set nocursorline
endfunction

function! ClearClipboard()
	let @+ = ""
endfunction

" no delay when exiting insert mode
set ttimeoutlen=0

" show partial command at bottom (TODO: default in 0.2. remove then)
set showcmd

" don't split words when wrapping
"set wrap linebreak nolist
set nowrap

" Show line numbers
set number

" Set tab width to 4 spaces
set tabstop=4
set shiftwidth=4

" Display 80 character line limit
set colorcolumn=81

" Highlight current light
set cursorline

" search
set ignorecase
set smartcase
set incsearch
set hlsearch

set clipboard^=unnamedplus

" case insensitive filename completion
set wildignorecase

" file and command completion
set wildmenu
set wildmode=longest,list,full

" remove file browser banner
let g:netrw_banner=0

" show tabs and trailing whitespace visually
set list listchars=tab:»\ ,trail:·,nbsp:␣,extends:→,precedes:←

" redraw only when we need to (disabled: cursor flashes with showcmd)
"set lazyredraw

" persistent undo. undodir must exist!
"set undodir=~/.config/nvim/undo
"set undofile

" don't open preview window on completion
set completeopt-=preview

" map leader
nnoremap <Space> <nop>
let mapleader="\<Space>"

" edit and source .vimrc
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :so $MYVIMRC<CR>

" save and quit faster
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" reload all buffers
nnoremap <leader>E :bufdo e<CR>

" unload and delete current buffer from list
nnoremap <leader>X :bd<CR>

" close current window (pane)
nnoremap <leader>x :close<CR>

" go to last used buffer
nnoremap <BS> <C-^>

" turn off search highlight
nnoremap <Esc><Esc> :noh<CR>

" exit terminal mode with Esc
tnoremap <Esc> <C-\><C-n>

" navigate wrapped lines (for when I have wrapping enabled)
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap j gj
vnoremap k gk
vnoremap <Down> gj
vnoremap <Up> gk

" force hjkl for navigation
"nnoremap <Left> <nop>
"nnoremap <Right> <nop>
"nnoremap <Up> <nop>
"nnoremap <Down> <nop>
"inoremap <Left> <nop>
"inoremap <Right> <nop>
"inoremap <Up> <nop>
"inoremap <Down> <nop>

" pane switching remap (not needed with vim-tmux-navigator)
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

" vp doesn't replace paste buffer
function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction
function! s:Replace()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<CR>"
endfunction
vnoremap <silent> <expr> p <sid>Replace()

" delete to black hole register
nnoremap d "_d
nnoremap dd "_dd
nnoremap x "_x
nnoremap s "_s

vnoremap d "_d

" don't continue comments on next line
"autocmd FileType * setlocal formatoptions-=c fo-=r fo-=o

" resize windows directionally with Alt-hjkl
function! IsRightmost()
	let oldw = winnr()
	silent! exe "normal! \<C-w>l"
	let neww = winnr()
	silent! exe oldw.'wincmd w'
	return oldw == neww
endfunction

function! IsBottom()
	let oldw = winnr()
	silent! exe "normal! \<C-w>j"
	let neww = winnr()
	silent! exe oldw.'wincmd w'
	return oldw == neww
endfunction

function! SetWinAdjust()
	if IsRightmost()
		nnoremap <M-l> <C-w><
		nnoremap <M-h> <C-w>>
	else
		nnoremap <M-l> <C-w>>
		nnoremap <M-h> <C-w><
	endif

	if IsBottom()
		nnoremap <M-k> <C-w>+
		nnoremap <M-j> <C-w>-
	else
		nnoremap <M-k> <C-w>-
		nnoremap <M-j> <C-w>+
	endif
endfun
autocmd! WinEnter * call SetWinAdjust()

" splits (consistent with tmux bindings)
set splitbelow
set splitright
nnoremap <silent> <leader>- :sp<CR>
nnoremap <silent> <leader>\ :vsp<CR>

" folding
set foldmethod=indent
set foldlevelstart=99
nnoremap <space><space> za

" colors
set termguicolors	" truecolor
set background=dark

if filereadable(expand("~/.vimrc_background"))
	let base16colorspace = 256
	source ~/.vimrc_background
endif

" airline
set laststatus=2
let g:airline_theme = 'base16_tomorrow'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#tab_nr_type = 2
"let g:airline#extensions#tabline#buffer_nr_show=1

" ctrlp
"let g:ctrlp_show_hidden=1 " causes errors when used in home
"let g:ctrlp_switch_buffer = 0
nnoremap <leader>f :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>m :CtrlPMixed<CR>
nnoremap <leader>M :CtrlPMRUFiles<CR>
nnoremap <leader>F :CtrlPCurWD<CR>
" TODO: ctags binding here at some point

" the silver searcher
if executable('ag')
	" use ag over grep
	set grepprg="ag --nogroup --nocolor"

	" use ag in ctrlp
	let g:ctrlp_user_command='ag %s -l --nocolor -g ""'

	" ag is fast enough that ctrlp doesn't need to cache
	"let g:ctrlp_use_caching=0
endif

" YouCompleteMe
let g:ycm_show_diagnostics_ui = 0
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/.ycm_extra_conf.py'
let g:ycm_extra_conf_vim_data = ['&filetype']

" deoplete
let g:deoplete#enable_at_startup = 1
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"
inoremap <expr> <CR> deoplete#close_popup() . "\<CR>"

" neomake
autocmd! BufWritePost * Neomake

"let g:neomake_c_enabled_makers=['clang', 'gcc']
let g:neomake_c_clang_args = ['-fsyntax-only', '-Wall', '-Wextra', '-xc']

"let g:neomake_cpp_enabled_makers=['clang', 'gcc']
let g:neomake_cpp_clang_args = ['-fsyntax-only', '-Wall', '-Wextra', '-xc++', '-std=c++11']

"let g:neomake_python_python_exe = 'python2'
let g:neomake_python_pycodestyle_args = ['--ignore=E501,E121,E123,E126,E226,E24,E704,W503']
