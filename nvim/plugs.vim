let s:vimdata = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
let s:plug_vim = s:vimdata . '/autoload/plug.vim'
let s:plug_dir = s:vimdata . '/pack'


" Automatically get and load the plugin if it doesn't exist.
" See https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob(s:plug_vim))
  silent execute '!curl -fLo '.s:plug_vim.' --create-dirs ' .
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  exe 'source ' . s:plug_vim
endif


call plug#begin(s:plug_dir)
Plug 'neovim/nvim-lspconfig'
Plug 'reksar/nvim-lsp-python'
call plug#end()


" Automatically install missing plugins.
" See https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation-of-missing-plugins
" NOTE: `g:plugs` exists if at least one `Plug` is defined.
if exists('g:plugs')
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
  \| endif
endif
