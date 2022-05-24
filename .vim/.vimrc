"My personal vim settings

set autoindent

set autowrite

set background=dark
call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'morhetz/gruvbox'
call plug#end()

colorscheme gruvbox

