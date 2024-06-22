-- pose.lua: All custom Lua code goes here to keep compatibility with vim (not
-- neovim).
-- Adapted using: https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

-- Native Neovim LSP
-- ================

-- Set up Mason to install and resolve LSPs
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")

local ensure_installed = {  "rust_analyzer", "tsserver", "bashls", "vimls", "jdtls", "kotlin_language_server", "jqls"}

print(vim.inspect(os.getenv("GOPATH")))
if os.getenv("GOPATH") then
  table.insert(ensure_installed, "gopls")
end

mason_lspconfig.setup({ ensure_installed = ensure_installed })

require('mason-tool-installer').setup {
  ensure_installed = ensure_installed
}

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Set up nvim-cmp.
local cmp = require 'cmp'

-- Migrated line from vimscript
-- Disabled 2023-07-23 does it mess up with the returns?
-- vim.o.completeopt = "menu,menuone,noselect"

-- Mappings.
local opts = { noremap = true, silent = true }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
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
    ['<C-b>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
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

-- Disable annoying completion for Markdown
cmp.setup.filetype('markdown', {
  completion = {
    autocomplete = false
  }
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

-- this part is telling Neovim to use the lsp server
require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  --
  --2023-02-19 Lua not working: https://github.com/williamboman/mason.nvim/issues/995
  -- ["lua-language-server"] = function ()
  --   require("lspconfig")["lua-language-server"].setup {
  --   settings = {
  --     -- Lua for Neovim specific settings
  --     Lua = {
  --       diagnostics = {
  --         -- Get the language server to recognize the `vim` global
  --         globals = { 'vim' },
  --       },
  --       runtime = {
  --         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
  --         version = 'LuaJIT',
  --       },
  --       workspace = {
  --         -- Make the server aware of Neovim runtime files
  --         library = vim.api.nvim_get_runtime_file("", true),
  --       },
  --       -- Do not send telemetry data containing a randomized but unique identifier
  --       telemetry = {
  --         enable = false,
  --       },
  --     }
  --   }
  --   }
  -- end
}

-- this is for diagnositcs signs on the line number column
-- use this to beautify the plain E W signs to more fun ones
-- !important nerdfonts needs to be setup for this to work in your terminal
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require('nvim-treesitter.configs').setup {
  -- one of "all", "maintained" (parsers with maintainers),
  -- or a list of languages
  ensure_installed = { "javascript", "typescript", "comment", "vim", "lua", "java", "kotlin", "svelte", "go", "typescript"},
  indent = { enable = true },
  highlight = {
    enable = true,
  },
}

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Start indent-blankline.nvim
require("ibl").setup()
