" plug
call plug#begin()
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'ghifarit53/tokyonight-vim'
    Plug 'Yggdroot/indentLine'
    Plug 'jeetsukumaran/vim-indentwise'
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'vim-airline/vim-airline'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
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
set encoding=UTF-8

" clipboard mappings
function! ClipboardMapping()
    if  exists("$WAYLAND_DISPLAY")
        vnoremap <silent> <C-c> :w !wl-copy<CR><CR>
    else
        vnoremap <C-c> "+y
    endif
endfunction
call ClipboardMapping()

" Selection shortcuts mappings
inoremap <C-a> <Esc>gg<S-v><S-g>

" fix indentation mappings
nnoremap <S-Tab> gg<S-v><S-g>=2<C-o>

" terminal resizing
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-
nnoremap <C-Right> :vert res+1<CR>
nnoremap <C-Left> :vert res-1<CR>

set noequalalways

" Indentwise
map [- <Plug>(IndentWisePreviousLesserIndent)
map [= <Plug>(IndentWisePreviousEqualIndent)
map [+ <Plug>(IndentWisePreviousGreaterIndent)
map ]- <Plug>(IndentWiseNextLesserIndent)
map ]= <Plug>(IndentWiseNextEqualIndent)
map ]+ <Plug>(IndentWiseNextGreaterIndent)
map [_ <Plug>(IndentWisePreviousAbsoluteIndent)
map ]_ <Plug>(IndentWiseNextAbsoluteIndent)
map [% <Plug>(IndentWiseBlockScopeBoundaryBegin)
map ]% <Plug>(IndentWiseBlockScopeBoundaryEnd)

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
let NERDTreeShowHidden=1

let g:NERDTreeShowLineNumbers=1
autocmd BufEnter NERD_* setlocal rnu

" asyncomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" fzf
nnoremap <c-p> :Files<CR>
command! -bang HomeFiles call fzf#vim#files('~/', <bang>0) 
nnoremap <s-p> :HomeFiles<CR>
nnoremap <c-f> :Rg<CR>

" vim-lsp
" set foldmethod=expr
"   \ foldexpr=lsp#ui#vim#folding#foldexpr()
"   \ foldtext=lsp#ui#vim#folding#foldtext()
let g:lsp_semantic_enabled = 1

" vim-vsnip
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript', 'html']
let g:vsnip_filetypes.typescriptreact = ['typescript', 'html']

