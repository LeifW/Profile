filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set guioptions-=T
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
autocmd! BufNewFile * silent! 0r ~/.vim/skel/tmpl.%:e
syntax on
set expandtab
set tabstop=2
set shiftwidth=2
