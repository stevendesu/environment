"*****************************************************************************
"" Basic Settings
"*****************************************************************************

"" Best practice
if has('vim_starting')
  set nocompatible
endif

"" Input behavior
set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set mousemodel=popup

"" Visual
set ruler
set number
set showcmd
syntax on
set gfn=Monospace\ 10
colorscheme monokai

if (exists('+colorcolumn'))
	set colorcolumn=80
	highlight ColorColumn ctermbg=236 guibg=236
endif

"" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

"" Backups
set backupdir=~/.config/nvim/backup,.
set directory=~/.config/nvim/backup,.

"" Recommended, but I want to verify I won't ever use comma first
"let mapleader=','

"" Recommended, but I don't understand it
"set hidden

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

"*****************************************************************************
"" Plug Packages
"*****************************************************************************

call plug#begin(expand('~/.config/nvim/plugged'))

"Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'bronson/vim-trailing-whitespace'

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

call plug#end()

"*****************************************************************************
"" Encoding
"*****************************************************************************

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

set fileformats=unix,dos,mac

"*****************************************************************************
"" Session Management
"*****************************************************************************

let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"*****************************************************************************
"" Abbreviations
"*****************************************************************************

"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
cnoreabbrev qw wq
cnoreabbrev Qw wq
cnoreabbrev qW wq
cnoreabbrev QW wq

"" Search mappings: These will make it so that going to the next one in a
"" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

"*****************************************************************************
"" Syntastic
"*****************************************************************************

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0

"Checkers

let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_python_checkers=['flake8', 'pylint']

