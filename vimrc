set nocompatible

" Plugins {{{
" Use Vim Plug to manage plugins
" Install it with follow
" $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin()
" Theme
Plug 'altercation/vim-colors-solarized'
" Tools
Plug 'scrooloose/nerdtree'                  " Tree file manager
Plug 'lambdalisue/vim-pyenv'
" Autocomplete

" Plug 'prabirshrestha/async.vim'
" Plug 'ilex/asyncomplete.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()
" }}}

" Plugins Options {{{

" Autocomplete {{{
    " debug
    " let g:lsp_log_verbose = 1
    " let g:lsp_log_file = expand('~/vim-lsp.log')

    " set completeopt=menuone,menu,longest,preview
    " let g:asyncomplete_remove_duplicates = 1
    " let g:asyncomplete_log_file = expand('~/asyncomplete.log')
    " let g:asyncomplete_lsp_log_file = expand('~/asyncomplete-lsp.log')
    " Python
    " if executable('pyls')
    "     " pip install python-language-server
    "     au User lsp_setup call lsp#register_server({
    "         \ 'name': 'pyls',
    "         \ 'cmd': {server_info->['pyls']},
    "         \ 'priority': 3,
    "         \ 'whitelist': ['python'],
    "         \ })
    " endif
" let g:asyncomplete_auto_popup = 1

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ asyncomplete#force_refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " Use Tab to navigate
    " inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    " inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" " }}}


set backspace=indent,eol,start 

" func Handler(channel, msg)
"     echo 'x'
" endfunc

" function! Acomp(timer)
"     let g:channel = ch_open('127.0.0.1:8888', {'callback': "Handler"})
"     " call ch_sendexpr(g:channel, 'xxx')
"     echom ch_evalexpr(g:channel, 'xxx')
"     echom ch_evalexpr(g:channel, 'yyy')
" endfunction

" let timer = timer_start(1500, 'Acomp',
" 				\ {'repeat': 3})
let g:channel = ch_open('127.0.0.1:8888')
echo ch_status(g:channel)
echo ch_evalexpr(g:channel, {'src': "import os\nimport a", 'line': 2, 'col': 8, 'path': 'example.py'})
echo ch_evalexpr(g:channel, {'src': "import os\nimport os.p", 'line': 2, 'col': 11, 'path': 'example.py'})
