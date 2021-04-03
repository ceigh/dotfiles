call plug#begin('~/.local/share/nvim/plugged')
" COMPLETION
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

" LINTER
Plug 'dense-analysis/ale'

" BAR
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/vim-gitbranch'

" THEMES
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'bluz71/vim-moonfly-colors'
Plug 'danilo-augusto/vim-afterglow'

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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'farmergreg/vim-lastplace'
call plug#end()


" COMMON
syntax on
let g:afterglow_italic_comments=1
let g:afterglow_inherit_background=1
colorscheme afterglow
set number
set expandtab
set shiftwidth=2
set tabstop=2
set cursorline
" Full color pallete
set termguicolors
" Hide mode name under bar
set noshowmode
" Remove autocomplete meta information in new window
set completeopt-=preview
" For parcel hot reloading
set backupcopy=yes
" Change window title to current filename
set title
set titleold=Shell

"HIGHLIGHTS
" highlight ExtraChars ctermbg=Magenta ctermfg=White guibg=Magenta guifg=White
" Alpha
highlight Normal ctermbg=NONE guibg=NONE

" MAXLEN
" set colorcolumn=70
" set textwidth=70
let w:m1=matchadd('Error', '\%>70v.\+', -1)

" MAPPINGS
" Tree
nnoremap mn :NERDTreeToggle<CR>
nnoremap Mn :NERDTreeFind<CR>
" Show full lint message
nnoremap <F3> :ALEDetail<CR>
" Fix lint issues
nnoremap <F4> :ALEFix<CR>
" Fix lint issues
nnoremap <F5> :ALENext<CR>
" Complete by tab
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" Comment -in/-out
xnoremap tc :s/^/# /<CR>:noh<CR>
xnoremap Tc :s/^# //<CR>:noh<CR>

" NERDTREE
" Hide swap files
let NERDTreeIgnore = ['\.swp$']

" DEOPLETE
let g:deoplete#enable_at_startup = 1
" Vue ts support
let g:nvim_typescript#vue_support = 1
let g:nvim_typescript#diagnostics_enable = 0

" AUTOSAVE
let g:auto_save = 1
" Remove trailing spaces on save
let g:auto_save_presave_hook = '%s/\s\+$//e'

" INDENTLINE
" Remove color highlight
" let g:indentLine_setColors = 0

" LIGHTLINE
" Change colorscheme
let g:lightline = { 'colorscheme': 'jellybeans' }
" Git branch
let g:lightline.component_function = { 'gitbranch': 'gitbranch#name' }
" Ale warnings and errors
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
" Placement
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
