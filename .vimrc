" plug
call plug#begin()
    Plug 'ghifarit53/tokyonight-vim'
    Plug 'preservim/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
call plug#end()

set nocompatible          " get rid of Vi compatibility mode. SET FIRST!
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]
set t_Co=256              " enable 256-color mode.
syntax enable             " enable syntax highlighting (previously syntax on).
set number                " show line numbers
set relativenumber
set laststatus=2          " last window always has a statusline
filetype indent on        " activates indenting for files
" set nohlsearch            " Don't continue to highlight searched phrases.
set hlsearch
set incsearch             " But do highlight as you type your search.
set ignorecase            " Make searches case-insensitive.
set ruler                 " Always show info along bottom.
set autoindent            " auto-indent
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
set smarttab              " use tabs at the start of a line, spaces elsewhere
set nowrap                " don't wrap text

" clipboard mappings
vnoremap <C-[> "+y

" color scheme setup
" tokyonight for vim
set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight

" transparent bg for a color scheme (must be below color scheme
hi Normal guibg=NONE ctermbg=NONE

" NERDTREE
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:NERDTreeWinPos = "right"

:let g:NERDTreeShowLineNumbers=1
:autocmd BufEnter NERD_* setlocal rnu

" fzf
nnoremap <c-p> :Files<CR>
command! -bang HomeFiles call fzf#vim#files('~/', <bang>0) 
nnoremap <s-p> :HomeFiles<CR>

