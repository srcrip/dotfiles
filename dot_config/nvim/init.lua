-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.o.shell = "/bin/bash"
vim.o.clipboard = "unnamedplus"
vim.o.jumpoptions = "stack"
vim.o.hlsearch = true
vim.o.textwidth = 120
vim.o.number = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.timeoutlen = 250
vim.o.ttimeoutlen = 100
vim.o.updatetime = 250
vim.o.tabstop = 2
vim.o.scrolloff = 999
vim.o.swapfile = false
vim.o.title = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cursorline = true
vim.o.smartindent = true
vim.o.virtualedit = "block"
vim.o.autowrite = true
vim.o.autoread = true
vim.o.autowriteall = true
vim.o.gdefault = true
vim.o.inccommand = "split"
vim.o.grepprg = "rg --vimgrep --smart-case --hidden"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.synmaxcol = 1500
vim.o.list = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.cmdheight = 2
vim.o.showtabline = 2
vim.o.laststatus = 3
vim.o.winborder = "rounded"
vim.o.winheight = 25

-- Folding settings
vim.o.foldenable = false
vim.o.foldmethod = "indent"
vim.o.foldnestmax = 2
vim.o.foldminlines = 5
vim.o.foldlevelstart = 1
vim.o.foldopen = ""
vim.o.foldclose = ""

-- Fill characters and diff options
vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.shortmess:append("c")
vim.opt.fillchars:append({ diff = " ", fold = "-" })
vim.opt.diffopt = { "internal", "filler", "algorithm:patience", "foldcolumn:0", "context:4" }

-- Create custom command
vim.api.nvim_create_user_command("Retab", function()
  vim.o.expandtab = true
  vim.cmd("retab")
end, {})

-- Enable filetype detection and syntax
-- vim.cmd("filetype plugin indent on")
-- vim.cmd("syntax enable")

function map(mode, key, action, opts)
  vim.keymap.set(mode, key, action, opts)
end

-- Normal mode mappings
vim.keymap.set("n", "<ESC>", ":noh<CR><ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "gp", "`[v`]", { noremap = true })
vim.keymap.set("n", "Q", "@q", { noremap = true })
vim.keymap.set("n", "gj", "J", { noremap = true })
vim.keymap.set("n", "<backspace>", "<c-^>", { noremap = true })
vim.keymap.set('n', '<c-g>', function()
  local filepath = vim.fn.expand('%')
  if filepath == '' then
    print('No file')
  else
    local line_num = vim.fn.line('.')
    local filepath_with_line = filepath .. ':' .. line_num
    vim.fn.setreg('+', filepath_with_line)
    print(filepath_with_line .. ' (copied to clipboard)')
  end
end, { desc = 'Print and copy relative path to current file with line number' })
vim.keymap.set("n", "}", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"}\"<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "{", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"{\"<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "J", "}", { noremap = true })
vim.keymap.set({ "n", "v" }, "K", "{", { noremap = true })
vim.keymap.set("n", "gf", "gF", { noremap = true })
vim.keymap.set("n", "H", "^", { noremap = true })
vim.keymap.set("n", "L", "$", { noremap = true })
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })

-- Visual mode mappings
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>s", vim.cmd.w, { desc = "Save buffer" })

-- restore last cursor position
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
            not (ft:match("commit") and ft:match("rebase"))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], "nx", false)
        end
      end,
    })
  end,
})

-- set abbreviations
vim.keymap.set("ca", "WQ", "wq")
vim.keymap.set("ca", "Wq", "wq")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>tdl", function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual lines" })

-- turne diagnostic on and off
vim.keymap.set("n", "<leader>tdt", function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = new_config })
end, { desc = "Toggle diagnostic virtual text" })

vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic/[E]rror float" })

-- Window management stuff
vim.keymap.set("n", "<leader>wo", vim.cmd.only, { desc = "Close all other windows" })

vim.cmd([[
  function! RotateWindows()
    if !exists('t:splitType')
      let t:splitType = 'vertical'
    endif
    if t:splitType == 'vertical' " is vertical switch to horizontal
      windo wincmd K
      let t:splitType = 'horizontal'
    else " is horizontal switch to vertical
      windo wincmd H
      let t:splitType = 'vertical'
    endif
  endfunction

  com! Rotate :call ToggleWindowHorizontalVerticalSplit()<CR>
]])

vim.keymap.set("n", "<leader>wr", "<cmd>call RotateWindows()<CR>", { desc = "Rotate windows" })

-- Buffer management stuff
vim.keymap.set("n", "<c-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Cycle to the previous buffer" })
vim.keymap.set("n", "<c-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Cycle to the next buffer" })

-- Emacs style that I like
vim.keymap.set("n", "<c-x><c-k>", "<cmd>BufDel!<CR>", { desc = "Kill the current buffer" })
vim.keymap.set("n", "<c-x><c-s>", "<cmd>w<CR>", { desc = "Save the current buffer" })
vim.keymap.set("n", "<c-x><c-b>", "<cmd>FzfLua buffers<CR>", { desc = "Switch to a buffer" })

vim.cmd([[
  function! CloseAllOtherBuffers()
    let curr = bufnr("%")
    let last = bufnr("$")

    if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
    if curr < last | silent! execute (curr+1).",".last."bd" | endif
  endfunction

  com! BufOnly execute 'call CloseAllOtherBuffers()'
]])

vim.keymap.set("n", "<space>bo", "<cmd>BufOnly<CR>", { desc = "Close all other buffers" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>vu", vim.pack.update, { desc = "Update plugins" })
vim.keymap.set("n", "<leader>vr", function()
  -- should you `:restart` here instead?
  vim.cmd.source("~/.config/nvim/init.lua")
  vim.cmd.nohl()
end, { desc = "Reload config" })
vim.keymap.set("n", "<leader>vo", function()
  vim.cmd("e ~/.local/share/nvim/site/pack/core/opt")
end, { desc = "Open plugin directory" })
vim.keymap.set("n", "<leader>vd", function()
  local plugin = vim.fn.input("Plugin name: ")
  vim.pack.del({ plugin })
end, { desc = "Delete plugin" })

local post_install_cmds = {
  ['blink.cmp'] = 'cargo build --release',
  ['nvim-treesitter'] = ':TSUpdate'
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack_post_install_commands', {}),
  desc = 'Run post installation commands',
  ---@param args {data:{kind:'install'|'update'|'delete', spec:vim.pack.SpecResolved, path:string}}
  callback = function(args)
    -- vim.notify('PackChanged: ' .. vim.inspect(args), vim.log.levels.DEBUG)

    if args.data.kind ~= 'update' then
      return
    end
    for name, cmd in pairs(post_install_cmds) do
      if args.data.spec.name == name then
        vim.notify('Running ' .. name .. ' post-install command: ' .. cmd, vim.log.levels.INFO)
        local ok = false
        local err = '' ---@type string?
        if vim.startswith(cmd, ':') then
          ---@diagnostic disable-next-line: param-type-mismatch
          ok, err = pcall(vim.cmd, cmd)
        else
          local obj = vim.system(vim.split(cmd, ' '), { cwd = args.data.path }):wait()
          ok = obj.code == 0
          err = obj.stderr
        end
        if ok then
          vim.notify(name .. ' post-install command successful', vim.log.levels.INFO)
        else
          vim.notify(name .. ' post-install command failed: ' .. err, vim.log.levels.ERROR)
        end
      end
    end
  end,
})

-- todo: try out: https://github.com/mawkler/demicolon.nvim

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/windwp/nvim-ts-autotag",
  -- "https://github.com/HawkinsT/pathfinder.nvim",
  "https://github.com/folke/flash.nvim",
  -- "https://github.com/srcrip/ultrakai",
  -- "file:///Users/marble/dev/lookup.nvim",
  -- "https://github.com/srcrip/lookup.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/supermaven-inc/supermaven-nvim",
  "https://github.com/ojroques/nvim-bufdel",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/mbbill/undotree",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/svermeulen/vim-subversive",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  -- "https://github.com/neovim/nvim-lspconfig",
  -- "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/gbprod/yanky.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/kosayoda/nvim-lightbulb",
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/vim-test/vim-test",
  "https://github.com/Saghen/blink.cmp"
}, { load = true })

require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true,          -- Auto close tags
    enable_rename = true,         -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- -- Also override individual filetype configs, these take priority.
  -- -- Empty by default, useful if one of the "opts" global settings
  -- -- doesn't work well in a specific filetype
  -- per_filetype = {
  --   ["html"] = {
  --     enable_close = false
  --   }
  -- }
})


require("yanky").setup {
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 150,
  },
}

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "CurSearch", { fg = "#EEEEEE", bg = "#008bb5" })
    vim.api.nvim_set_hl(0, "Search", { bg = "#585e6e" })

    vim.api.nvim_set_hl(0, "YankyPut", { link = "CurSearch" })
    vim.api.nvim_set_hl(0, "YankyYanked", { link = "CurSearch" })

    vim.api.nvim_set_hl(0, "Folded", { fg = "#75715E", bg = "#272822" })
  end,
})

-- see: https://github.com/gbprod/yanky.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- unimpaired style
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

require("blink.cmp").setup {
  signature = { enabled = true },
  enabled = function()
    -- Enable only in specific filetypes
    local filetypes = { 'codecompanion' }
    return vim.tbl_contains(filetypes, vim.bo.filetype)
  end,
}

-- packadd lookup.nvim
vim.cmd.packadd("lookup.nvim")

require('lookup').setup({
  use_lsp = true,
  picker = 'fzf-lua',
})

vim.keymap.set('n', 'gd', require('lookup').lookup_definition, { desc = 'Go to definition' })

vim.cmd.colorscheme("ultrakai")

require("supermaven-nvim").setup {
  ignore_filetypes = { codecompanion = true }
}

require("bufdel").setup { next = "alternate" }

require("which-key").setup {
  delay = 0,
  spec = {
    { "<leader>b", group = "[B]uffers" },
    { "<leader>w", group = "[W]indows" },
    { "<leader>f", group = "[F]ind" },
    { "<leader>t", group = "[T]ests" },
    { "<leader>d", group = "[D]iagnostics" },
    -- { "<leader>td", group = "[T]oggle [D]iagnostics" },
    { "<leader>h", group = "Git [H]unk",   mode = { "n", "v" } },
  }
}

-- undotree setup
map('n', 'U', '<C-r>')
map('n', '<C-\\>', ':UndotreeToggle<CR>')

vim.g.undotree_WindowLayout = 4
vim.g.undotree_SplitWidth = 25
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_HelpLine = 0
vim.g.undotree_HighlightChangedText = 0
vim.g.undotree_ShortIndicators = 1

vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.undoreload = 10000

require("bufferline").setup {
  options = {
    show_buffer_close_icons = false,
    show_close_icon = false,
    custom_filter = function(buf_number)
      return vim.bo[buf_number].filetype ~= "qf"
    end,
  },
  highlights = {
    fill = {
      bg = "#272822",
    },
    buffer_selected = {
      bg = "#272822",
    },
  },
}

require("lazydev").setup {
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
}

require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
  formatters_by_ft = {
    lua = { "lua_ls" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
  },
  formatters = {
    prettier = {
      cwd = function()
        local current_dir = vim.fn.getcwd()
        local target_dir = vim.fn.expand("~/dev/Jump")

        -- Only use prettier if we're in the Jump monorepo
        if current_dir == target_dir then
          return current_dir
        end
        return nil
      end,
    },
  },
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- FormatToggle for per-buffer, FormatToggle! for global
vim.api.nvim_create_user_command("FormatToggle", function(args)
  if args.bang then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
  end

  print("Autoformat: " .. vim.inspect(vim.b.disable_autoformat))
end, {
  desc = "Toggle autoformat-on-save",
  bang = true,
})

map("n", "<leader>tf", function()
  vim.cmd("FormatToggle")
end, { desc = "Toggle autoformat-on-save for this buffer" })
map("n", "<leader>tF", function()
  vim.cmd("FormatToggle!")
end, { desc = "Toggle autoformat-on-save globally" })

-- Subversive plugin mappings
map('n', 's', '<Plug>(SubversiveSubstitute)')
map('n', 'ss', '<Plug>(SubversiveSubstituteLine)')
map('n', 'S', '<Plug>(SubversiveSubstituteToEndOfLine)')
map('x', 's', '<Plug>(SubversiveSubstitute)')
map('x', 'p', '<Plug>(SubversiveSubstitute)')
map('x', 'P', '<Plug>(SubversiveSubstitute)')

-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

require('mini.ai').setup({
  custom_textobjects = {
    -- Configure 'b' to match any bracket or quote
    b = {
      { '%b()', '%b[]', '%b{}', '%b""', "%b''" },
      '^.().*().$'
    },
  }
})

require("mini.cursorword").setup()

local statusline = require("mini.statusline")

statusline.setup({ use_icons = vim.g.have_nerd_font })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

require("nvim-treesitter.configs").setup {
  -- Missing required fields
  modules = {},
  sync_install = false,
  ignore_install = {},

  ensure_installed = {
    "bash",
    "c",
    "diff",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
    "elixir",
    "heex",
    "eex",
    "gleam",
    "rust",
    "tsx",
    "javascript",
    "typescript",
    "svelte",
    "css",
    "astro",
  },
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { "ruby" },
  },
  indent = { enable = true, disable = { "ruby" } },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
        ["aa"] = "@attribute.outer",
        ["ia"] = "@attribute.inner",
        -- -- doesnt seem to work with react
        -- ["ae"] = "@element.outer",
        -- ["ie"] = "@element.inner",
        ["ie"] = "@jsx_element.inner",
        ["ae"] = "@jsx_element.outer",

        ["ah"] = "@heex.outer",
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V',  -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
    },
  },
}

require 'treesitter-context'.setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false,      -- Enable multiwindow support.
  max_lines = 1,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

-- vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#272822" })

-- LSP setup
-- require("lspconfig").setup()
require("mason").setup()
require("fidget").setup()

-- local servers = {
--   ["elixir-ls"] = {},
--   lua_ls = {},
-- }
--
-- local ensure_installed = vim.tbl_keys(servers or {})
--
-- vim.list_extend(ensure_installed, {
--   -- can use this to make sure mason installs stuff other than the lsp's above
--   -- "prettierd",
-- })
--
-- require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

-- require("mason-lspconfig").setup({
--   ensure_installed = {}, -- explicitly set to an empty table (installs via mason-tool-installer instead)
--   automatic_installation = false,
--   handlers = {
--     function(server_name)
--       local server = servers[server_name] or {}
--       -- This handles overriding only values explicitly passed
--       -- by the server configuration above. Useful when disabling
--       -- certain features of an LSP (for example, turning off formatting for ts_ls)
--       server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
--       require("lspconfig")[server_name].setup(server)
--     end,
--   },
-- })


local fzf = require("fzf-lua")
local ivy_profile = require("fzf-lua.profiles.ivy")
local defaults = require("fzf-lua.defaults")

fzf.setup {
  "ivy",
  winopts = { preview = { default = "bat" }, treesitter = false },
  manpages = { previewer = "man_native" },
  helptags = { previewer = "help_native" },
  defaults = { git_icons = false, file_icons = false },
  lsp = { code_actions = { previewer = "codeaction_native" } },
  tags = { previewer = "bat" },
  btags = { previewer = "bat" },
  -- oldfiles = ivy_profile.lines,


  oldfiles = vim.tbl_extend("force", ivy_profile.blines,
    { actions = defaults.globals.actions.files }
  ),

  files = ivy_profile.lines,
  jumps = ivy_profile.blines,
  grep = {
    rg_glob = false, -- will trigger `opts.multiprocess = 1`
    rg_opts =
    " --color=always --column --line-number --no-heading --smart-case --max-columns=4096 -e",
  },
}

local function yank_selection()
  vim.cmd('normal! "vy')

  return vim.fn.getreg('v')
end

-- vim.keymap.set("v", "<space>/", ":lua require('fzf-lua').grep_visual()<cr>", { silent = true })
vim.keymap.set("v", "<space>/", fzf.grep_visual, { desc = "Search project" })
vim.keymap.set("n", "<space>/", fzf.grep_project, { desc = "Search project" })

vim.keymap.set("n", "<space>h", fzf.help_tags, { desc = "Search help" })
vim.keymap.set("v", "<space>h", function() fzf.help_tags({ query = yank_selection() }) end,
  { desc = "Search help" })

vim.keymap.set("n", "<space>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("v", "<space>fr", function() fzf.oldfiles({ query = yank_selection() }) end,
  { desc = "Recent files" })

vim.keymap.set("n", "<space><space>", fzf.files, { desc = "Find files" })
vim.keymap.set("v", "<space><space>", function() fzf.files({ query = yank_selection() }) end,
  { desc = "Find files" })

vim.keymap.set("n", "<space><cr>", fzf.resume, { desc = "Resume last search" })

vim.keymap.set("n", "<space>ff", fzf.builtin, { desc = "Available pickers" })

vim.keymap.set("n", "<space>fd", fzf.diagnostics_document, { desc = "Diagnostics from document" })
vim.keymap.set("n", "<space>fc", fzf.diagnostics_workspace, { desc = "Diagnostics from workspace" })

-- fugitive / git stuff
vim.keymap.set("n", "<space>gg", ":Git<cr>", { silent = true })
vim.keymap.set("n", "<space>gb", ":Gitsigns blame<cr>", { silent = true })

vim.cmd([[
  augroup FugitiveMappings
    autocmd!
    autocmd FileType fugitive nmap <buffer> <Tab> =

    "todo: this effects the status buffer and commits, figure out how to only make it affect commit buffers?
    " prevent fugitive buffers from being deleted when you leave them
    "autocmd FileType fugitive set bufhidden=
  augroup END
]])

vim.cmd("autocmd FileType gitcommit setlocal spell")

require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged_enable = true,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 300,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  -- shows pr numbers in blame
  gh = true,
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,  -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    -- local function map(mode, l, r, opts)
    --   opts = opts or {}
    --   opts.buffer = bufnr
    --   vim.keymap.set(mode, l, r, opts)
    -- end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)

    -- Actions
    -- map('n', '<leader>hs', gitsigns.stage_hunk)
    -- map('n', '<leader>hr', gitsigns.reset_hunk)
    -- map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
    -- map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
    -- map('n', '<leader>hS', gitsigns.stage_buffer)
    -- map('n', '<leader>hu', gitsigns.undo_stage_hunk)
    -- map('n', '<leader>hR', gitsigns.reset_buffer)
    map("n", "<leader>hp", gitsigns.preview_hunk)
    -- map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
    -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map("n", "<leader>hd", gitsigns.diffthis)
    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end)
    map("n", "<leader>td", gitsigns.toggle_deleted)

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})

require("nvim-lightbulb").setup({
  autocmd = { enabled = true }
})

require('mini.diff').setup()



local function fib(n)
  if n <= 1 then
    return n
  end
  return fib(n - 1) + fib(n - 2)
end

-- Here be AI stuff
vim.g.codecompanion_auto_tool_mode = true
require("codecompanion").setup {
  display = {
    diff = {
      enabled = false,
      provider = "mini_diff"
    }
  },
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = "cmd:op read op://personal/hsr6sue7y35hztd3gm5l3ojr6e/credential --no-newline",
        },
        schema = {
          extended_thinking = {
            default = false,
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "anthropic",
      auto_scroll = false,
      show_context = true,
      fold_context = false,
      show_settings = false,
      show_tools_processing = true
    },
    inline = {
      adapter = "anthropic",
    },
    cmd = {
      adapter = "anthropic",
    }
  },
  extensions = {
    fidget_progress = {
      enabled = true,
      opts = {},
      callback = {
        setup = function(ext_config)
          local progress = require("fidget.progress")
          local handles = {}

          local function store_progress_handle(id, handle)
            handles[id] = handle
          end

          local function pop_progress_handle(id)
            local handle = handles[id]
            handles[id] = nil
            return handle
          end

          local function llm_role_title(adapter)
            local parts = {}
            table.insert(parts, adapter.formatted_name)
            if adapter.model and adapter.model ~= "" then
              table.insert(parts, "(" .. adapter.model .. ")")
            end
            return table.concat(parts, " ")
          end

          local function create_progress_handle(request)
            local strategy = request.data.strategy or "unknown"
            return progress.handle.create({
              title = " Requesting assistance (" .. strategy .. ")",
              message = "In progress...",
              lsp_client = {
                name = llm_role_title(request.data.adapter),
              },
            })
          end

          local function report_exit_status(handle, request)
            if request.data.status == "success" then
              handle.message = "Completed"
            elseif request.data.status == "error" then
              handle.message = " Error"
            else
              handle.message = "󰜺 Cancelled"
            end
          end

          local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

          vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequestStarted",
            group = group,
            callback = function(request)
              local handle = create_progress_handle(request)
              store_progress_handle(request.data.id, handle)
            end,
          })

          vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequestFinished",
            group = group,
            callback = function(request)
              local handle = pop_progress_handle(request.data.id)
              if handle then
                report_exit_status(handle, request)
                handle:finish()
              end
            end,
          })
        end,

        exports = {
          clear_handles = function()
            -- Optional: function to clear all progress handles if needed
            vim.api.nvim_del_augroup_by_name("CodeCompanionFidgetHooks")
          end
        }
      }
    }
  }
}

-- configure vim-test
map("n", "<space>tf", ":TestFile<cr>", { silent = true })
map("n", "<space>tn", ":TestNearest<cr>", { silent = true })
map("n", "<space>tl", ":TestLast<cr>", { silent = true })

vim.cmd [[
  function! BufferTermStrategy(cmd)
    exec 'te ' . a:cmd
  endfunction

  let g:test#custom_strategies = {'bufferterm': function('BufferTermStrategy')}
  let g:test#strategy = 'bufferterm'
]]

-- Jump to Phoenix location annotations from html like:
-- <!-- <DemoWeb.CoreComponents.button> lib/demo_web/components/core_components.ex:543 (demo) -->
-- Assumes you have copied the annotation to your clipboard.
-- Just hit ctrl-c with the html comment selected in the inspector.
function PhoenixJumpFromClipboard()
  -- Get clipboard content
  local clipboard = vim.fn.getreg "+"

  -- Pattern to match file path and line number
  -- Looks for lib/path/file.ext:123 pattern
  local pattern = "([%w%._/-]+%.%w+):(%d+)"

  -- Extract file path and line number
  local file_path, line_number = string.match(clipboard, pattern)

  if file_path and line_number then
    -- Convert line number to integer
    line_number = tonumber(line_number)

    -- Try to open the file
    local ok, err = pcall(function()
      vim.cmd("edit " .. file_path)
      vim.api.nvim_win_set_cursor(0, { line_number, 0 })
    end)

    if not ok then
      print("Failed to jump to location: " .. err)
    else
      print("Jumped to " .. file_path .. " line " .. line_number)
    end
  else
    print "No file:line pattern found in clipboard"
  end
end

vim.api.nvim_create_user_command("PhoenixJump", PhoenixJumpFromClipboard, {})

-- map phoenix jump to <leader>pj
vim.keymap.set("n", "<leader>pj", PhoenixJumpFromClipboard, { desc = "Phoenix jump" })

vim.cmd.source("~/.config/nvim/ranger.vim")
map("n", "-", "<cmd>Ranger<CR>", { desc = "Open ranger" })

require('mini.files').setup()

-- todo: try https://github.com/folke/flash.nvim/issues/343
---@type Flash.Config
-- require("flash").setup {
--   jump = {
--     history = true,
--     register = true,
--   },
--   modes = {
--     search = {
--       enabled = false
--     }
--   }
-- }


-- {
--   -- labels = "abcdefghijklmnopqrstuvwxyz",
--   labels = "asdfghjklqwertyuiopzxcvbnm",
--   search = {
--     -- search/jump in all windows
--     multi_window = true,
--     -- search direction
--     forward = true,
--     -- when `false`, find only matches in the given direction
--     wrap = true,
--     ---@type Flash.Pattern.Mode
--     -- Each mode will take ignorecase and smartcase into account.
--     -- * exact: exact match
--     -- * search: regular search
--     -- * fuzzy: fuzzy search
--     -- * fun(str): custom function that returns a pattern
--     --   For example, to only match at the beginning of a word:
--     --   mode = function(str)
--     --     return "\\<" .. str
--     --   end,
--     mode = "exact",
--     -- behave like `incsearch`
--     incremental = false,
--     -- Excluded filetypes and custom window filters
--     ---@type (string|fun(win:window))[]
--     exclude = {
--       "notify",
--       "cmp_menu",
--       "noice",
--       "flash_prompt",
--       function(win)
--         -- exclude non-focusable windows
--         return not vim.api.nvim_win_get_config(win).focusable
--       end,
--     },
--     -- Optional trigger character that needs to be typed before
--     -- a jump label can be used. It's NOT recommended to set this,
--     -- unless you know what you're doing
--     trigger = "",
--     -- max pattern length. If the pattern length is equal to this
--     -- labels will no longer be skipped. When it exceeds this length
--     -- it will either end in a jump or terminate the search
--     max_length = false, ---@type number|false
--   },
--   jump = {
--     -- save location in the jumplist
--     jumplist = true,
--     -- jump position
--     pos = "start", ---@type "start" | "end" | "range"
--     -- add pattern to search history
--     history = false,
--     -- add pattern to search register
--     register = false,
--     -- clear highlight after jump
--     nohlsearch = false,
--     -- automatically jump when there is only one match
--     autojump = false,
--     -- You can force inclusive/exclusive jumps by setting the
--     -- `inclusive` option. By default it will be automatically
--     -- set based on the mode.
--     inclusive = nil, ---@type boolean?
--     -- jump position offset. Not used for range jumps.
--     -- 0: default
--     -- 1: when pos == "end" and pos < current position
--     offset = nil, ---@type number
--   },
--   label = {
--     -- allow uppercase labels
--     uppercase = true,
--     -- add any labels with the correct case here, that you want to exclude
--     exclude = "",
--     -- add a label for the first match in the current window.
--     -- you can always jump to the first match with `<CR>`
--     current = true,
--     -- show the label after the match
--     after = true, ---@type boolean|number[]
--     -- show the label before the match
--     before = false, ---@type boolean|number[]
--     -- position of the label extmark
--     style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
--     -- flash tries to re-use labels that were already assigned to a position,
--     -- when typing more characters. By default only lower-case labels are re-used.
--     reuse = "lowercase", ---@type "lowercase" | "all" | "none"
--     -- for the current window, label targets closer to the cursor first
--     distance = true,
--     -- minimum pattern length to show labels
--     -- Ignored for custom labelers.
--     min_pattern_length = 0,
--     -- Enable this to use rainbow colors to highlight labels
--     -- Can be useful for visualizing Treesitter ranges.
--     rainbow = {
--       enabled = false,
--       -- number between 1 and 9
--       shade = 5,
--     },
--     -- With `format`, you can change how the label is rendered.
--     -- Should return a list of `[text, highlight]` tuples.
--     ---@class Flash.Format
--     ---@field state Flash.State
--     ---@field match Flash.Match
--     ---@field hl_group string
--     ---@field after boolean
--     ---@type fun(opts:Flash.Format): string[][]
--     format = function(opts)
--       return { { opts.match.label, opts.hl_group } }
--     end,
--   },
--   highlight = {
--     -- show a backdrop with hl FlashBackdrop
--     backdrop = true,
--     -- Highlight the search matches
--     matches = true,
--     -- extmark priority
--     priority = 5000,
--     groups = {
--       match = "FlashMatch",
--       current = "FlashCurrent",
--       backdrop = "FlashBackdrop",
--       label = "FlashLabel",
--     },
--   },
--   -- action to perform when picking a label.
--   -- defaults to the jumping logic depending on the mode.
--   ---@type fun(match:Flash.Match, state:Flash.State)|nil
--   action = nil,
--   -- initial pattern to use when opening flash
--   pattern = "",
--   -- When `true`, flash will try to continue the last search
--   continue = false,
--   -- Set config to a function to dynamically change the config
--   config = nil, ---@type fun(opts:Flash.Config)|nil
--   -- You can override the default options for a specific mode.
--   -- Use it with `require("flash").jump({mode = "forward"})`
--   ---@type table<string, Flash.Config>
--   modes = {
--     -- options used when flash is activated through
--     -- a regular search with `/` or `?`
--     search = {
--       -- when `true`, flash will be activated during regular search by default.
--       -- You can always toggle when searching with `require("flash").toggle()`
--       enabled = false,
--       highlight = { backdrop = false },
--       jump = { history = true, register = true, nohlsearch = true },
--       search = {
--         -- `forward` will be automatically set to the search direction
--         -- `mode` is always set to `search`
--         -- `incremental` is set to `true` when `incsearch` is enabled
--       },
--     },
--     -- options used when flash is activated through
--     -- `f`, `F`, `t`, `T`, `;` and `,` motions
--     char = {
--       enabled = true,
--       -- dynamic configuration for ftFT motions
--       config = function(opts)
--         -- autohide flash when in operator-pending mode
--         opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
--
--         -- disable jump labels when not enabled, when using a count,
--         -- or when recording/executing registers
--         opts.jump_labels = opts.jump_labels
--           and vim.v.count == 0
--           and vim.fn.reg_executing() == ""
--           and vim.fn.reg_recording() == ""
--
--         -- Show jump labels only in operator-pending mode
--         -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
--       end,
--       -- hide after jump when not using jump labels
--       autohide = false,
--       -- show jump labels
--       jump_labels = false,
--       -- set to `false` to use the current line only
--       multi_line = true,
--       -- When using jump labels, don't use these keys
--       -- This allows using those keys directly after the motion
--       label = { exclude = "hjkliardc" },
--       -- by default all keymaps are enabled, but you can disable some of them,
--       -- by removing them from the list.
--       -- If you rather use another key, you can map them
--       -- to something else, e.g., { [";"] = "L", [","] = H }
--       keys = { "f", "F", "t", "T", ";", "," },
--       ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
--       -- The direction for `prev` and `next` is determined by the motion.
--       -- `left` and `right` are always left and right.
--       char_actions = function(motion)
--         return {
--           [";"] = "next", -- set to `right` to always go right
--           [","] = "prev", -- set to `left` to always go left
--           -- clever-f style
--           [motion:lower()] = "next",
--           [motion:upper()] = "prev",
--           -- jump2d style: same case goes next, opposite case goes prev
--           -- [motion] = "next",
--           -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
--         }
--       end,
--       search = { wrap = false },
--       highlight = { backdrop = true },
--       jump = {
--         register = false,
--         -- when using jump labels, set to 'true' to automatically jump
--         -- or execute a motion when there is only one match
--         autojump = false,
--       },
--     },
--     -- options used for treesitter selections
--     -- `require("flash").treesitter()`
--     treesitter = {
--       labels = "abcdefghijklmnopqrstuvwxyz",
--       jump = { pos = "range", autojump = true },
--       search = { incremental = false },
--       label = { before = true, after = true, style = "inline" },
--       highlight = {
--         backdrop = false,
--         matches = false,
--       },
--     },
--     treesitter_search = {
--       jump = { pos = "range" },
--       search = { multi_window = true, wrap = true, incremental = false },
--       remote_op = { restore = true },
--       label = { before = true, after = true, style = "inline" },
--     },
--     -- options used for remote flash
--     remote = {
--       remote_op = { restore = true, motion = true },
--     },
--   },
--   -- options for the floating window that shows the prompt,
--   -- for regular jumps
--   -- `require("flash").prompt()` is always available to get the prompt text
--   prompt = {
--     enabled = true,
--     prefix = { { "⚡", "FlashPromptIcon" } },
--     win_config = {
--       relative = "editor",
--       width = 1, -- when <=1 it's a percentage of the editor width
--       height = 1,
--       row = -1, -- when negative it's an offset from the bottom
--       col = 0, -- when negative it's an offset from the right
--       zindex = 1000,
--     },
--   },
--   -- options for remote operator pending mode
--   remote_op = {
--     -- restore window views and cursor position
--     -- after doing a remote operation
--     restore = false,
--     -- For `jump.pos = "range"`, this setting is ignored.
--     -- `true`: always enter a new motion when doing a remote operation
--     -- `false`: use the window's cursor position and jump target
--     -- `nil`: act as `true` for remote windows, `false` for the current window
--     motion = false,
--   },
-- }
--

-- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
-- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
-- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
-- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },

-- vim.keymap.set({ "n", "x", "o" }, "<enter>", function() require("flash").jump() end, { desc = "Flash" })

local disable_flash = {
  "quickfix",
  "loclist",
  "terminal",
  "prompt",
  "nofile",
  "help"
}

vim.keymap.set({ "n", "x", "o" }, "<enter>", function()
  local buftype = vim.bo.buftype
  if vim.tbl_contains(disable_flash, buftype) then
    -- Execute default <enter> behavior
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<enter>", true, false, true), "n", false)
  else
    require("flash").jump()
  end
end, { desc = "Flash" })
