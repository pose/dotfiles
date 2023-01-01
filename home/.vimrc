" force vim, required
set nocompatible

" required
filetype off

call plug#begin()

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

" nvim-lspconfig
Plug 'neovim/nvim-lspconfig'

" VSCode theme
Plug 'tomasiser/vim-code-dark'

" vim-argumentative: Move function arguments around
Plug 'PeterRincker/vim-argumentative'

" Syntax highlighting for jq
Plug 'bfrg/vim-jq'

" Autocomplete powered by nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" vsnip (required by nvim-cmp)
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'


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

" Native Neovim LSP
" -----------------
set completeopt=menu,menuone,noselect
lua << EOF
-- Mappings.
local opts = { noremap=true, silent=true }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<space>K', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
end
-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  completion = {
    -- Avoid annoying prompt when :q, :w, etc.
    keyword_length = 2
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- this part is telling Neovim to use the lsp server
local servers = {  'tsserver', 'bashls', 'vimls' }
for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
    }
end

-- this is for diagnositcs signs on the line number column
-- use this to beautify the plain E W signs to more fun ones
-- !important nerdfonts needs to be setup for this to work in your terminal
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " } 
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
end


EOF

" Undodir
" -------
set undodir=~/.vim/undo-dir
set undofile

colorscheme codedark

" If .vimrc.local file exists, source that file at the end
if filereadable(expand('~/.vimrc.local'))
  exe 'source ~/.vimrc.local'
endif
