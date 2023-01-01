" force vim, required
set nocompatible

" required
filetype off

call plug#begin()

function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Plugs
" -------

" add .editorconfig support
Plug 'editorconfig/editorconfig-vim'

" add typescript-vim (support for .ts files)
Plug 'leafgarland/typescript-vim'

" Display indent levels
Plug 'lukas-reineke/indent-blankline.nvim'

" add applescript support
Plug 'vim-scripts/applescript.vim'

" add jdaddy.vim: JSON manipulation and pretty printing
Plug 'tpope/vim-jdaddy'

" add vim-surround: Operations on '', "", [], etc.
Plug 'tpope/vim-surround'

" add commentary.vim: Comment stuff with gcc
Plug 'tpope/vim-commentary'

" add vim-javascript
Plug 'pangloss/vim-javascript'

" add :Remove, :Move, :Rename, :Mkdir, :SudoWrite, :SudoRead
Plug 'tpope/vim-eunuch'

" add gf to jump between node requires
Plug 'moll/vim-node'

" support for .jsx/.tsx/typescript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Dim inactive windows
Plug 'blueyed/vim-diminactive'

" VSCode theme
Plug 'tomasiser/vim-code-dark'

" vim-argumentative: Move function arguments around
Plug 'PeterRincker/vim-argumentative'

" Neovim-exclusive plugins
" See https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation

" Neovim Lua plugin development
Plug 'folke/neodev.nvim', Cond(has('nvim'))

" Syntax highlighting for jq
Plug 'bfrg/vim-jq', Cond(has('nvim'))

" Mason to download required LSP servers
Plug 'williamboman/mason.nvim', Cond(has('nvim'))
Plug 'williamboman/mason-lspconfig.nvim', Cond(has('nvim'))

" nvim-lspconfig
Plug 'neovim/nvim-lspconfig', Cond(has('nvim'))

" Autocomplete powered by nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp', Cond(has('nvim'))
Plug 'hrsh7th/cmp-buffer', Cond(has('nvim'))
Plug 'hrsh7th/cmp-path', Cond(has('nvim'))
Plug 'hrsh7th/cmp-cmdline', Cond(has('nvim'))
Plug 'hrsh7th/nvim-cmp', Cond(has('nvim'))

" vsnip (required by nvim-cmp)
Plug 'hrsh7th/cmp-vsnip', Cond(has('nvim'))
Plug 'hrsh7th/vim-vsnip', Cond(has('nvim'))


" All of your Plugins must be added before the following line
call plug#end()

" Leader options
" --------------
" change the mapleader from \ to ,
let mapleader=","

" reduce : 2 keystrokes with -
nnoremap - :

" Tabs, Spaces and Indent
" -----------------------

set expandtab
set autoindent                      " always set autoindenting on
set copyindent                      " copy the previous indentation on autoindenting
set tabstop=2                       " a tab is four spaces
set backspace=indent,eol,start      " allow backspacing over everything in insert mode
set smarttab                        " insert tabs on the start of a line according to shiftwidth, not tabstop
set shiftwidth=2                    " number of spaces to use for autoindenting
set shiftround                      " use multiple of shiftwidth when indenting with '<' and '>'

" Always show at least one line above/below the cursor
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

" Custom tab options for different languages
" ------------------------------------------

filetype plugin on

filetype indent on

autocmd filetype python             set expandtab shiftwidth=4 tabstop=4
autocmd filetype java               set expandtab shiftwidth=4 tabstop=4
autocmd filetype html               set expandtab shiftwidth=2 tabstop=2
autocmd filetype javascript         set expandtab shiftwidth=2 tabstop=2
autocmd filetype markdown           set expandtab shiftwidth=2 tabstop=2
autocmd filetype markdown           set tw=79 formatoptions+=t

" Editing vim files
" -----------------
" Source selection by doing <leader>sop
noremap <leader>sop :source %<CR>

" Search
" ------
set showmatch                       " set show matching parenthesis
set ignorecase                      " ignore case when searching
set smartcase                       " ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch                        " highlight search terms
set incsearch                       " show search matches as you type

" Misc
" ----
set wildignore=*.swp,*.bak,*.pyc,*.class,node_modules,dist,build,coverage

set history=1000                    " remember more commands and search history
set undolevels=1000                 " use many muchos levels of undo
set title                           " change the terminal's title
set visualbell                      " don't beep
set noerrorbells                    " don't beep
set exrc                            " If .vimrc file found in project directory should override the default

set nobackup
set noswapfile

set hidden

syntax enable

set mouse=a

" pressing down jumps to the next row in the editor (much more natural when wrap is enabled)
nnoremap <Down> gj
nnoremap <Up> gk

" Save buffer when FocusLost (like IntelliJ)
au FocusLost * silent! wa
set autowriteall
set autoread

autocmd QuickFixCmdPost *grep* cwindow

set listchars=nbsp:¬,tab:>-,extends:»,precedes:«,trail:•
set list

"highlights cursor line
set cursorline
"highlights cursor column
set cursorcolumn

" set number for easier jump
set number
" set relative line numbers
set relativenumber

" show status bar
set laststatus=2

" F1, F2, F3...
" -------------
nmap <silent> <F2><up>              :split<CR>
nmap <silent> <F2><down>            :split<CR>
nmap <silent> <F2><left>            :vsplit<CR>
nmap <silent> <F2><right>           :vsplit<CR>

" Open splits by default right and down (my mind seems to handle
" that better)
set splitright
set splitbelow

set pastetoggle=<F5>

" FZF Mapping
" -------------
nnoremap <silent> <leader>t :FZF<cr>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" vim-diminactive config
" ----------------------
hi ColorColumn ctermbg=0 guibg=#eee8d5

" Undodir
" -------
set undodir=~/.vim/undo-dir
set undofile

colorscheme codedark

" If .vimrc.local file exists, source that file at the end
if filereadable(expand('~/.vimrc.local'))
  exe 'source ~/.vimrc.local'
endif
