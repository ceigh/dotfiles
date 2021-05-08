call plug#begin('~/.local/share/nvim/plugged')
" COMPLETION
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-clang'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

" LINTER
Plug 'dense-analysis/ale'

" SYNTAX
Plug 'posva/vim-vue'
Plug 'cakebaker/scss-syntax.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jparise/vim-graphql'
Plug 'digitaltoad/vim-pug'
Plug 'cespare/vim-toml'
Plug 'antonk52/vim-browserslist'

" MISC
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug '907th/vim-auto-save'
Plug 'jiangmiao/auto-pairs'
Plug 'gregsexton/MatchTag'
Plug 'alvan/vim-closetag'
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-css-color'
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'farmergreg/vim-lastplace'
call plug#end()

" COMMON
syntax on
set number
set expandtab
set shiftwidth=2
set tabstop=2
set title
set cursorline
set colorcolumn=80
" let &colorcolumn=join(range(81, 999), ",")

" HIGHLIGHT
highlight CursorLine cterm=NONE ctermbg=8
highlight CursorLineNR cterm=NONE ctermbg=8
highlight ColorColumn ctermbg=3

" MAPPINGS
" Tree
nnoremap mn :NERDTreeToggle<CR>
nnoremap Mn :NERDTreeFind<CR>
" Show full lint message
nnoremap ad :ALEDetail<CR>
" Fix lint issues
nnoremap af :ALEFix<CR>
" Fix lint issues
nnoremap an :ALENext<CR>
" Complete by tab
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" NERDTREE
" Hide swap files
let NERDTreeIgnore = ['\.swp$']

" DEOPLETE
let g:deoplete#enable_at_startup = 1
" Vue ts support
" let g:nvim_typescript#vue_support = 1
" let g:nvim_typescript#diagnostics_enable = 0

" AUTOSAVE
let g:auto_save = 1
" Remove trailing spaces on save
let g:auto_save_presave_hook = '%s/\s\+$//e'

" CLOSETAG
let g:closetag_filetypes = 'xml,html,vue'
" Remove autoclose outside vue's <template> section
let g:closetag_regions = { 'vue': 'htmlTag' }
