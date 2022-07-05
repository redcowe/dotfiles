"My personal vim settings

set autoindent

set autowrite

set number

set background=dark
call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
call plug#end()

colorscheme gruvbox

