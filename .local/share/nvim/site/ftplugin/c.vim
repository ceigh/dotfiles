" HOT KEYS
" build and run
nnoremap <buffer><F4> :!gcc -o %:r.o % && ./%:r.o<CR>


" DEOPLETE
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/10.0.1/include'
let g:deoplete#sources#clang#sort_algo = 'priority'
let g:deoplete#sources#clang#include_default_arguments = 1
let g:deoplete#sources#clang#filter_availability_kinds = ['Deprecated', 'NotAvailable', 'NotAccessible']
