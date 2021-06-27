call plug#begin('~/.local/share/nvim/plugged')
" nerdtree
Plug 'scrooloose/nerdtree' |
  \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight' |
  \ Plug 'Xuyuanp/nerdtree-git-plugin' |
  \ Plug 'ryanoasis/vim-devicons'

" syntax
Plug 'posva/vim-vue'
Plug 'cakebaker/scss-syntax.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'digitaltoad/vim-pug'
Plug 'kevinoid/vim-jsonc'
Plug 'tomlion/vim-solidity'

" other
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'danilo-augusto/vim-afterglow'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug '907th/vim-auto-save'
Plug 'gregsexton/MatchTag'
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-css-color'
Plug 'farmergreg/vim-lastplace'
call plug#end()

" colors
set termguicolors
syntax on
let g:afterglow_italic_comments = 1
let g:afterglow_inherit_background = 1
colorscheme afterglow

" tab
set expandtab
set tabstop=2
set shiftwidth=0

" lines
set number
set cursorline
set colorcolumn=80
  " use colors from exist highlights
exec "hi CursorLineNr guibg="
  \ . synIDattr(synIDtrans(hlID('CursorLine')), "bg#")
exec "hi ColorColumn guibg="
  \ . synIDattr(synIDtrans(hlID('CursorLineNr')), "fg#")
  " change split color
exec "hi VertSplit guibg="
  \ . synIDattr(synIDtrans(hlID('CursorLine')), "bg#")

" restore cursor shape on exit
augroup RestoreCursorShapeOnExit
  autocmd!
  autocmd VimLeave * set guicursor=a:ver25-blinkon250
augroup END

" indentline
let g:indentLine_concealcursor = 'nc'

" nerdtree
  " start when vim is started without file arguments
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
  " hide files
let NERDTreeIgnore = ['\.swp$', 'node_modules']
  " icons for git plugin
let g:NERDTreeGitStatusUseNerdFonts = 1
  " remove scroll lag
let g:NERDTreeLimitedSyntax = 1
  " mappings
nmap <silent> mn :NERDTreeToggle <Return>
nmap <silent> Mn :NERDTreeFind <Return>

" nerdcommenter
  " https://github.com/preservim/nerdcommenter#default-mappings
let mapleader = ','
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" autosave
let g:auto_save = 1
  " remove trailing spaces on save
let g:auto_save_presave_hook = '%s/\s\+$//e'

" closetag
let g:closetag_filetypes = 'vue,html,xml'
  " remove autoclose outside vue's <template> section
let g:closetag_regions = { 'vue': 'htmlTag' }

" airline
set noshowmode
let g:airline_section_y = ''
let g:airline_section_z = '%l:%c/%L %p%%'

" gitgutter
set updatetime=100

" coc https://github.com/neoclide/coc.nvim#example-vim-configuration
let g:coc_global_extensions = [
  \ 'coc-json', 'coc-eslint', 'coc-pairs', 'coc-snippets', 'coc-tailwindcss',
  \ 'coc-css', 'coc-tsserver', 'coc-vetur', 'coc-markdownlint', 'coc-sh',
  \ 'coc-stylelintplus', 'coc-stylelint', 'coc-vimlsp',
  \ 'coc-yaml', 'coc-explorer', 'coc-diagnostic'
  \ ]
  " textEdit might fail if hidden is not set
set hidden
  " some servers have issues with backup files
set nobackup
set nowritebackup
  " don't pass messages to |ins-completion-menu|
set shortmess+=c
  " complete by tab
inoremap <silent> <expr> <Tab>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction
  " use <C-Space> to trigger completion
inoremap <silent> <expr> <C-Space> coc#refresh()
  " make <Return> auto-select the first completion
inoremap <silent> <expr> <Return> pumvisible() ? coc#_select_confirm()
    \: "\<C-g>u\<Return>\<C-r>=coc#on_enter()\<Return>"
  " diagnostic navigation
nmap <silent> dp <Plug>(coc-diagnostic-prev)
nmap <silent> dn <Plug>(coc-diagnostic-next)
nmap <silent> da :CocDiagnostics <Return>
  " goto navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
  " highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
  " symbol renaming.
nmap <silent> rn <Plug>(coc-rename)
  " format current buffer on <leader>f
nmap <silent> <leader>f :call CocAction('format') <Return>
  " organize imports of the current buffer on <leader>o
nmap <silent> <leader>o
  \ :call CocAction('runCommand', 'editor.action.organizeImport') <Return>
  " applying codeAction to the selected region
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
  " change colors
    " sign
hi link CocErrorSign DiffDelete
hi link CocWarningSign DiffChange
hi link CocInfoSign CocWarningSign
hi link CocHintSign CocInfoSign
    " float
hi link CocErrorFloat NormalFloat
hi link CocWarningFloat CocErrorFloat
hi link CocInfoFloat CocWarningFloat
hi link CocHintFloat CocInfoFloat
