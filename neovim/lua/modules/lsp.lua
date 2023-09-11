vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>t', "trouble", { desc = "Open diagnostics list" })

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
  -- print("attaching " .. client.name .. " to buffer " .. bufnr)

  local map = function(mode, keys, func, opts)
    local options = { noremap = true }

    if opts then
      options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, keys, func, options)
  end

  map('n', '<leader>rn', vim.lsp.buf.rename)
  map('n', 'ga', vim.lsp.buf.code_action)

  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'gr', require('telescope.builtin').lsp_references)
  map('n', 'gI', vim.lsp.buf.implementation)
  map('n', '<leader>D', vim.lsp.buf.type_definition)
  map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols)
  map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  -- See `:help K` for why this keymap
  map('n', '<leader>k', vim.lsp.buf.hover)
  map('n', '<C-k>', vim.lsp.buf.signature_help)

  -- Lesser used LSP functionality
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder)
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder)

  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_buf_create_user_command(0, 'Format',
    function(opts)
      if client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({
          group = augroup,
          bufnr = bufnr,
          -- async = true
        })
      end
    end,
    {})

  -- call it on save
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = "silent! undojoin | silent! Format"
  })

  if client.server_capabilities.documentSymbolProvider then
    local navic = require("nvim-navic")
    navic.attach(client, bufnr)
  end
end

--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  tailwindcss = {},
  cssls = {},
  svelte = {},
  elixirls = {},
  volar = {},
  tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  eslint = {
    -- on_attach = function(client, bufnr)
    --   on_attach(client, bufnr)
    --   vim.cmd [[autocmd BufWritePre .tsx,.ts,*.jsx,*.js EslintFixAll]]
    -- end,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx",
      "vue", "svelte" }
  },
  emmet_language_server = {
    filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug",
      "typescriptreact", "vue", "eelixir" },
    init_options = {
      --- @type table<string, any> https://docs.emmet.io/customization/preferences/
      preferences = {},
      --- @type "always" | "never" defaults to `"always"`
      showexpandedabbreviation = "always",
      --- @type boolean defaults to `true`
      showabbreviationsuggestions = true,
      --- @type boolean defaults to `false`
      showsuggestionsassnippets = false,
      --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
      syntaxprofiles = {},
      --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
      variables = {},
      --- @type string[]
      excludelanguages = {},
    },
  }
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,


      on_attach = function(client, bufnr)
        xpcall(function()
          on_attach(client, bufnr)
        end, function(err)
          print(debug.traceback(err))
        end)
      end,

      -- on_attach = on_attach,
      -- on_attach = function(client, bufnr)
      --   xpcall(on_attach(client, bufnr), handle_error)
      -- end,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}
