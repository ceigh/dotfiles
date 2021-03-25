" VIM-VUE
" trim preprocessors
let g:vue_pre_processors = ['pug', 'typescript', 'sass', 'scss']


" ALE
" alias
let b:ale_linter_aliases = [
\ 'html',
\ 'pug',
\ 'sass',
\ 'scss',
\ 'css',
\ 'typescript',
\ 'javascript'
\]
let b:ale_linters = ['stylelint', 'eslint']
" fixers
let b:ale_fixers = ['eslint']


" DEOPLETE
let g:deoplete#sources#ternjs#filetypes = ['vue']

" HOTKEYS
nnoremap <F6> :TSDoc<CR>
nnoremap <F7> :TSDefPreview<CR>
