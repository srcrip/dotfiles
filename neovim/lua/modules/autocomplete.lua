-- Setup nvim-cmp.
local cmp = require 'cmp'

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
  experimental = {
    ghost_text = false
  },
  -- window = {
  --   documentation = cmp.config.window.bordered(),
  --   completion = cmp.config.window.bordered(),
  -- },
  view = {
    -- entries = {name = 'wildmenu', separator = '|' }
    entries = {
      name = 'custom',
      selection_order = 'near_cursor',
    }
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For vsnip users.
    end,
  },
  -- completion = {
  --   completeopt = "menu,menuone,noinsert",
  -- },
  mapping = {
    ["<C-k>"] = cmp.mapping({
      i = function()
        if cmp.visible() then
          cmp.abort()
        else
          cmp.complete()
        end
      end,
      c = function()
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end,
    }),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ['<c-backspace>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<Tab>"] = function(fallback)
      if vim.cmd [[call copilot#GetDisplayedSuggestion()]].text then
        print("there is a suggestion")
      else
        print("no suggestion")
      end

      -- !empty(s.text)
      if cmp.visible() then
        cmp.select_next_item()
        -- elseif vim.fn["vsnip#available"](1) > 0 then
        --   u.input("<Plug>(vsnip-expand-or-jump)")
      else
        local copilot_keys = vim.fn["copilot#Accept"]()
        if copilot_keys ~= "" then
          vim.api.nvim_feedkeys(copilot_keys, "i", true)
        else
          fallback()
        end
      end
    end,
  },
  -- mapping = cmp.mapping.preset.insert({
  --   ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --   ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --   ['<C-Space>'] = cmp.mapping.complete(),
  --   -- ['<backspace>'] = cmp.mapping(function(fallback)
  --   --   if cmp.visible()  then
  --   --     cmp.abort()
  --   --   else
  --   --     fallback()
  --   --   end
  --   -- end, { "i", "s" }),
  --   ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set select to false to only confirm explicitly selected items.
  --   ["<Tab>"] = cmp.mapping(function(fallback)
  --     -- if cmp.visible() and has_words_before() then
  --     --   cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  --     -- else
  --     --   fallback()
  --     -- end

  --     -- vim.defer_fn(function()
  --     --   if cmp.visible() then
  --     --     cmp.abort()
  --     --     require("modules.toggle_completion").toggle_completion()
  --     --   else
  --     --     cmp.complete()
  --     --     require("modules.toggle_completion").toggle_completion()
  --     --   end
  --     -- end, 500)



  --     if cmp.visible() then
  --       cmp.select_next_item()
  --     elseif vim.fn["vsnip#available"](1) == 1 then
  --       feedkey("<Plug>(vsnip-expand-or-jump)", "")
  --     else
  --       -- fallback()
  --       vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n',
  --         true)
  --     end
  --   end, { "i", "s" }),
  --   ["<S-Tab>"] = cmp.mapping(function()
  --     if cmp.visible() then
  --       cmp.select_prev_item()
  --     elseif vim.fn["vsnip#jumpable"](-1) == 1 then
  --       feedkey("<Plug>(vsnip-jump-prev)", "")
  --     end
  --   end, { "i", "s" }),
  -- }),
  sources = cmp.config.sources({
    -- { name = "copilot", group_index = 2 },
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the cmp_git source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for / (if you enabled native_menu, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled native_menu, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
