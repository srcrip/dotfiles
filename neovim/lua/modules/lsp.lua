vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>t', "trouble", { desc = "Open diagnostics list" })

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

vim.diagnostic.config({
  float = {
    border = 'rounded',
    source = "if_many"
  }
})

vim.keymap.set('i', '<c-s>', function() vim.lsp.buf.signature_help() end, { buffer = true })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers['signature_help'], {
    border = 'single',
    close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
  }
)

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
  vim.notify("attaching " .. client.name .. " to buffer " .. bufnr)

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
  map('n', 'gD', vim.lsp.buf.type_definition)
  map('n', 'gr', require('telescope.builtin').lsp_references)
  map('n', 'gI', vim.lsp.buf.implementation)
  map({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help)
  map('n', '<leader>k', vim.lsp.buf.hover)

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

local servers = {
  rust_analyzer = {},
  html = { filetypes = { 'html' } },
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
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}
