call plug#begin('~/.local/share/nvim/plugged')
" AUTOCOMPLETION
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" c/c++
Plug 'zchee/deoplete-clang'
" js
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
" ts
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

" LINTER
Plug 'dense-analysis/ale'

" DIRECTORY TREE
Plug 'scrooloose/nerdtree'

" GIT CHANGES
Plug 'airblade/vim-gitgutter'

" AUTO SAVE
Plug '907th/vim-auto-save'

" AUTO PAIRS
Plug 'jiangmiao/auto-pairs'

" INDENT LINE
" Plug 'Yggdroot/indentLine'

" BOTTOM BAR
Plug 'itchyny/lightline.vim'
" linters info
Plug 'maximbaz/lightline-ale'
" branch name
Plug 'itchyny/vim-gitbranch'

" CLOSETAG AUTOCLOSE HTML TAGS
Plug 'alvan/vim-closetag'

" MATCHING TAGS HIGHLIGHT
Plug 'gregsexton/MatchTag'

" CSS COLORS
Plug 'ap/vim-css-color'

" THEME
" Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'bluz71/vim-moonfly-colors'

" SYNTAX
" vue
Plug 'posva/vim-vue'
" fixed typescript
Plug 'HerringtonDarkholme/yats.vim'
" Plug 'leafgarland/typescript-vim'
" graphql
Plug 'jparise/vim-graphql'
" pug
Plug 'digitaltoad/vim-pug'
" Plug 'evanleck/vim-svelte'
" Plug 'purescript-contrib/purescript-vim'
" Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
call plug#end()

" HOT KEYS
" tree
nnoremap <F2> :NERDTreeToggle<CR>
" show full lint message
nnoremap <F3> :ALEDetail<CR>
" fix lint issues
nnoremap <F4> :ALEFix<CR>
" complete by tab
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" show under cursor regions
" nnoremap zS :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
" show/hide line numbers
nnoremap zn :set nonumber<CR>
nnoremap zN :set number<CR>
" comment -in/-out
xnoremap tc :s/^/# /<CR>:noh<CR>
xnoremap Tc :s/^# //<CR>:noh<CR>

" COMMON
" enable syntax highlight
syntax on
" full color pallete
set termguicolors
" scheme
" colorscheme dracula
colorscheme moonfly
" transparency
highlight Normal guibg=NONE ctermbg=NONE
" todo
highlight Todo ctermbg=DarkYellow ctermfg=Black guibg=DarkYellow guifg=Black
" line numbers
set number
" set relativenumber
" tab to space
set expandtab
" tab width
set shiftwidth=2
set tabstop=2
" highlight current line
set cursorline
" hide mode name under lightline
set noshowmode
" remove autocomplete meta information in new window
set completeopt-=preview
" for parcel hot reloading
set backupcopy=yes

" NERDTREE
" hide swap files
let NERDTreeIgnore = ['\.swp$']
" let g:NERDTreeDirArrowExpandable = '+'
" let g:NERDTreeDirArrowCollapsible = '-'

" DEOPLETE
let g:deoplete#enable_at_startup = 1
" vue ts support
let g:nvim_typescript#vue_support = 1
let g:nvim_typescript#diagnostics_enable = 0

" AUTOSAVE
let g:auto_save = 1
" remove trailing spaces on save
let g:auto_save_presave_hook = '%s/\s\+$//e'

" INDENTLINE
" remove color highlight
" let g:indentLine_setColors = 0

" LIGHTLINE
" change colorscheme
let g:lightline = { 'colorscheme': 'moonfly' }
" git branch
let g:lightline.component_function = { 'gitbranch': 'gitbranch#name' }
" ale warnings and errors
let g:lightline.component_expand = {
\  'linter_checking': 'lightline#ale#checking',
\  'linter_infos': 'lightline#ale#infos',
\  'linter_warnings': 'lightline#ale#warnings',
\  'linter_errors': 'lightline#ale#errors',
\  'linter_ok': 'lightline#ale#ok',
\}
let g:lightline.component_type = {
\  'linter_checking': 'right',
\  'linter_infos': 'right',
\  'linter_warnings': 'warning',
\  'linter_errors': 'error',
\  'linter_ok': 'right',
\}
let g:lightline#ale#indicator_checking = 'LINTING'
" placement
let g:lightline.active = {
\  'left': [
\    ['mode', 'paste'],
\    ['gitbranch', 'readonly', 'filename', 'modified']
\  ],
\  'right': [
\    ['lineinfo'],
\    ['percent'],
\    ['fileformat', 'fileencoding', 'filetype'],
\    ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok']
\  ]
\}

" ALE
" let g:ale_fix_on_save = 1

" CLOSETAG
let g:closetag_filetypes = 'html,vue'
" remove autoclose outside vue's <template> section
let g:closetag_regions = {
\  'vue': 'htmlTag'
\}
