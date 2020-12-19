" ALE
" static linking
let b:ale_linters_static = ['hlint', 'stack_build']
" dynamic
let b:ale_linters_dynamic = b:ale_linters_static + ['ghc']

" set
let b:ale_linters = b:ale_linters_static

" for ghc dynamic linking
let b:ale_haskell_ghc_options = '-dynamic -fno-code -v0'

" lint with dynamic linking
nnoremap ald :let b:ale_linters=b:ale_linters_dynamic<CR>
  \ :ALELint<CR>:echo 'lint with dynamic linking enabled'<CR>
" lint with static linking
nnoremap als :let b:ale_linters=b:ale_linters_static<CR>
  \ :ALELint<CR>:echo 'lint with static linking enabled'<CR>
