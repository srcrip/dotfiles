require("lsp-format").setup {}

function buf_map(buf, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, opts or { silent = true })
end

-- Show diagnostic float when cursor holds.
--  TODO add a command to open this
-- vim.cmd [[
--   autocmd CursorHold * lua vim.diagnostic.open_float(nil,{focusable=false,scope="cursor"})
-- ]]

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = true,
  -- This is from a cool plugin called lsp_lines but it doesn't quite work for me yet.
  virtual_lines = false
  -- virtual_lines = { only_current_line = true }
})

-- local lsp_status = require('lsp-status')
-- lsp_status.register_progress()

local signature_config = {
  bind = true,
  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
  -- set to 0 if you DO NOT want any API comments be shown
  -- This setting only take effect in insert mode, it does not affect signature help in normal
  -- mode, 10 by default

  max_height = 12, -- max height of signature floating_window
  max_width = 80, -- max_width of signature floating_window
  noice = false, -- set to true if you using noice to render markdown
  wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long

  floating_window = false, -- show hint in a floating window, set to false for virtual text only mode

  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
  -- will set to true when fully tested, set to false will use whichever side has more space
  -- this setting will be helpful if you do not want the PUM and floating win overlap

  floating_window_off_x = 1, -- adjust float windows x position. 
  -- can be either a number or function
  floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
  -- can be either number or function, see examples

  close_timeout = 4000, -- close floating window after ms when laster parameter is entered
  fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "parameter: ",  -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
  hint_scheme = "String",
  hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
  handler_opts = {
    border = "rounded"   -- double, rounded, single, shadow, none, or a table of borders
  },

  always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 150, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'

  select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
  move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

local on_attach = function(client, bufnr)
  local signature = require('lsp_signature')
  signature.on_attach(signature_config, bufnr)

  -- TODO: formatting is totally broken on elixirls
  -- require("lsp-format").on_attach(client)

  -- lsp_status.on_attach(client)

  -- Go to definition
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  buf_map(bufnr, "n", "gd", ":LspDef<CR>")

  -- Hover
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  buf_map(bufnr, "n", "<space>k", ":LspHover<CR>")

  -- Select a code action
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")

  -- Rename
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  buf_map(bufnr, "n", "gR", ":LspRename<CR>")

  -- Go to references
  vim.cmd("command! LspReferences lua vim.lsp.buf.references()")
  buf_map(bufnr, "n", "gr", ":LspReferences<CR>")

  -- Format
  vim.cmd("command! LspFormat lua vim.lsp.buf.format({async=true})")
  buf_map(bufnr, "n", "<space>f", ":LspFormat<CR>")

  -- Highlight words under cursor
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
    })
  end
end

require("mason").setup {
  ui = {
    icons = {
      package_installed = "✓"
    }
  }
}

require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    "tailwindcss",
    "svelte",
    "solargraph",
    "elixirls",
    "volar",
    "tsserver",
    "eslint",
    "cssls"
  },
}


local nvim_lsp = require "lspconfig"

-- Tailwind
nvim_lsp.tailwindcss.setup {
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- CSS
nvim_lsp.cssls.setup {
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- Svelte
nvim_lsp.svelte.setup {
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- Ruby
nvim_lsp.solargraph.setup {
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- Elixir
nvim_lsp.elixirls.setup {
  -- settings = {
  --   cmd = { "elixir-ls" },
  -- },
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- Vue
nvim_lsp.volar.setup {
  filetypes = { 'vue' },
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- Typescript
nvim_lsp.tsserver.setup {
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- Lua
nvim_lsp.lua_ls.setup {
  cmd = { "lua-language-server" },
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end
}

-- Eslint
nvim_lsp.eslint.setup {
  -- capabilities = lsp_status.capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.cmd [[autocmd BufWritePre .tsx,.ts,*.jsx,*.js EslintFixAll]]
  end,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx",
    "vue", "svelte" }
}
