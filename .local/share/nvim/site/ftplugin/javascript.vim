" ALE
" standard
let b:ale_linters_standard = ['standard']
" all linters
let b:ale_linters_all = b:ale_linters_standard + ['eslint']

" set
let b:ale_linters = b:ale_linters_all
let b:ale_fixers = b:ale_linters_all

" lint with all linters
nnoremap ala :let b:ale_linters=b:ale_linters_all<CR>
  \ :let b:ale_fixers=b:ale_linters_all<CR>
  \ :ALELint<CR>:echo 'lint with all linters enabled'<CR>
" lint with just standard
nnoremap als :let b:ale_linters=b:ale_linters_standard<CR>
  \ :let b:ale_fixers=b:ale_linters_standard<CR>
  \ :ALELint<CR>:echo 'lint with standard only enabled'<CR>
