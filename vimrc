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

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction


function! s:check_do_complete() abort
    let col = col('.') - 1
    return col && getline('.')[0:col - 1]  =~ '\h\w\*\.\=$'
endfunction

" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ asyncomplete#force_refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " Use Tab to navigate
    inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" " }}}
set completeopt=menu,menuone,noselect

set backspace=indent,eol,start 

let g:channel = ch_open('127.0.0.1:8888')

inoremap <F5> <C-R>=JediComplete()<CR>

func! JediCompleteHandler(channel, msg)
    let l:completions = []
    for l:comp in a:msg
        call add(l:completions, {'abbr': l:comp['name'], 'word': l:comp['complete'], 'menu': l:comp['description']})
    endfor
    
    call complete(col('.'), l:completions)
endfunc

func! GetContext()
    let l:pos = getcurpos()
    let l:ret = {'src': join(getline(1, '$'), "\n"), 'line': l:pos[1], 'col': l:pos[2] - 1, 'path': expand('%:p')}
    " let l:ret = {'bufnr':bufnr('%'), 'curpos':getcurpos(), 'changedtick':b:changedtick}
    " let l:ret['lnum'] = l:ret['curpos'][1]
    " let l:ret['col'] = l:ret['curpos'][2]
    " let l:ret['filetype'] = &filetype
    " let l:ret['filepath'] = expand('%:p')
    " let l:ret['typed'] = strpart(getline(l:ret['lnum']),0,l:ret['col']-1)
    return l:ret
endfunc

func! JediComplete()
    let l:ctx = GetContext()
    call ch_sendexpr(g:channel, l:ctx, {'callback': "JediCompleteHandler"})
    return ''
endfunc

augroup vim_complete 
    autocmd! * <buffer>
    " autocmd InsertEnter <buffer> call s:python_cm_insert_enter()
    " autocmd InsertEnter <buffer> call s:change_tick_start()
    " autocmd InsertLeave <buffer> call s:change_tick_stop()
    " working together with timer, the timer is for detecting changes
    " popup menu is visible. TextChangedI will not be triggered when popup
    " menu is visible, but TextChangedI is more efficient and faster than
    " timer when popup menu is not visible.
    autocmd TextChangedI <buffer> call s:on_text_changed()
augroup END

func! StartComplete(last_curpos, x)
    if a:last_curpos == getcurpos()
        call JediComplete()
    endif
endfunc

func! s:on_text_changed()
    if s:check_do_complete()
        call timer_start(200, function('StartComplete', [getcurpos()]))
    endif
endfunc


