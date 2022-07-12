" See https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let s:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
let s:plug_vim = s:data_dir . '/autoload/plug.vim'
if empty(glob(s:plug_vim))
  silent execute '!curl -fLo '.s:plug_vim.' --create-dirs '.s:url
  source $MYVIMRC
endif

let s:plugs_dir = s:data_dir . '/pack'
call plug#begin(s:plugs_dir)
Plug 'neovim/nvim-lspconfig'
call plug#end()

" See https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation-of-missing-plugins
" `g:plugs` exists if at least one `Plug` is defined.
if exists('g:plugs')
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
  \| endif
endif
