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

function map(mode, key, action, opts)
  vim.keymap.set(mode, key, action, opts)
end

-- Normal mode mappings - RESOLVED CONFLICT
vim.keymap.set("n", "<ESC>", ":noh<CR><ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "gp", "`[v`]", { noremap = true })
vim.keymap.set("n", "Q", "@q", { noremap = true })
vim.keymap.set("n", "gj", "J", { noremap = true })
vim.keymap.set("n", "<backspace>", "<c-^>", { noremap = true })

-- Improved <c-g> function from HEAD
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

-- Apply to both normal and visual modes for better consistency
vim.keymap.set({ "n", "v" }, "J", "}", { noremap = true })
vim.keymap.set({ "n", "v" }, "K", "{", { noremap = true })
vim.keymap.set("n", "gf", "gF", { noremap = true })
vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true })
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true })
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

vim.keymap.set("n", "<leader>bo", "<cmd>BufOnly<CR>", { desc = "Close all other buffers" })

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

vim.pack.add({
  "https://github.com/barrettruth/diffs.nvim",
  "https://github.com/kokusenz/deltaview.nvim",
  "https://github.com/rbong/vim-flog",
  "https://github.com/junegunn/gv.vim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/greggh/claude-code.nvim",
  -- "https://github.com/emmanueltouzery/agitator.nvim",
  -- "https://github.com/aaronhallaert/advanced-git-search.nvim",
  "https://github.com/FredeHoey/tardis.nvim",
  "https://github.com/folke/sidekick.nvim",
  "https://github.com/petertriho/nvim-scrollbar",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/folke/flash.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/supermaven-inc/supermaven-nvim",
  "https://github.com/ojroques/nvim-bufdel",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/mbbill/undotree",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/stevearc/conform.nvim",
  -- "https://github.com/svermeulen/vim-subversive",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/gbprod/yanky.nvim",
  "https://github.com/gbprod/substitute.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/kosayoda/nvim-lightbulb",
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/vim-test/vim-test", -- from HEAD
  "https://github.com/Saghen/blink.cmp",  -- from HEAD
  -- "https://github.com/notjedi/nvim-rooter.lua" -- from incoming
  --
}, { load = true })

require("claude-code").setup({
  -- Terminal window settings
  window = {
    split_ratio = 0.5,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = "botright",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true,    -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window

    -- Floating window configuration (only applies when position = "float")
    float = {
      width = "80%",       -- Width: number of columns or percentage string
      height = "80%",      -- Height: number of rows or percentage string
      row = "center",      -- Row position: number, "center", or percentage string
      col = "center",      -- Column position: number, "center", or percentage string
      relative = "editor", -- Relative to: "editor" or "cursor"
      border = "rounded",  -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
  -- File refresh settings
  refresh = {
    enable = true,             -- Enable file change detection
    updatetime = 100,          -- updatetime when Claude Code is active (milliseconds)
    timer_interval = 1000,     -- How often to check for file changes (milliseconds)
    show_notifications = true, -- Show notification when files are reloaded
  },
  -- Git project settings
  git = {
    use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
  },
  -- Shell-specific settings
  shell = {
    separator = '&&',    -- Command separator used in shell commands
    pushd_cmd = 'pushd', -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
    popd_cmd = 'popd',   -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  },
  -- Command settings
  command = "claude", -- Command used to launch Claude Code
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = "--continue", -- Resume the most recent conversation
    resume = "--resume",     -- Display an interactive conversation picker

    -- Output options
    verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = "<C-,>",          -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = "<C-,>",        -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
        verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  }
})

vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })

require('tardis-nvim').setup {
  keymap = {
    ["next"] = '<C-j>',             -- next entry in log (older)
    ["prev"] = '<C-k>',             -- previous entry in log (newer)
    ["quit"] = 'q',                 -- quit all
    ["revision_message"] = '<C-m>', -- show revision message for current revision
    ["commit"] = '<C-g>',           -- replace contents of origin buffer with contents of tardis buffer
  },
  settings = {
    initial_revisions = 10,    -- initial revisions to create buffers for
    max_revisions = 256,       -- max number of revisions to load
    show_commit_index = false, -- append [index|total] to buffer names when browsing revisions
  },
}

local trouble = require("trouble")
trouble.setup({})

local sidekick = require("sidekick")
sidekick.setup({})

-- {
--   "<leader>ac",
--   function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
--   desc = "Sidekick Toggle Claude",
-- },

vim.keymap.set("n", "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
  { desc = "Sidekick Toggle Claude" })

require("scrollbar").setup()

-- PLUGIN SETUP - RESOLVED CONFLICT: Combine both setups

-- nvim-ts-autotag setup
require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false
  },
})

-- Yanky setup from HEAD with full configuration
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

-- Yanky keymaps
-- Doing this instead of YankyPutBefore and YankyPutAfter auto indents all pasted text properly
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutIndentBeforeLinewise)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

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

require("substitute").setup({
  on_substitute = require("yanky.integration").substitute(),
})

vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- Blink.cmp setup for codecompanion
require("blink.cmp").setup {
  signature = { enabled = true },
  enabled = function()
    local filetypes = { 'codecompanion' }
    return vim.tbl_contains(filetypes, vim.bo.filetype)
  end,
}

-- Lookup plugin setup
vim.cmd.packadd("lookup.nvim")
require('lookup').setup({
  use_lsp = true,
  picker = 'fzf-lua',
})
vim.keymap.set('n', 'gd', require('lookup').lookup_definition, { desc = 'Go to definition' })

-- todo: rooter breaks several things like my jump to file phoenix jump thing...
-- require('nvim-rooter').setup {
--   rooter_patterns = { 'mix.exs', '.git' },
--   trigger_patterns = { '*' },
--   manual = false,
--   fallback_to_parent = false,
--   cd_scope = "global",
-- }

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

-- trying out this instead: https://github.com/gbprod/substitute.nvim
-- -- Subversive plugin mappings
-- map('n', 's', '<Plug>(SubversiveSubstitute)')
-- map('n', 'ss', '<Plug>(SubversiveSubstituteLine)')
-- map('n', 'S', '<Plug>(SubversiveSubstituteToEndOfLine)')
-- map('x', 's', '<Plug>(SubversiveSubstitute)')
-- map('x', 'p', '<Plug>(SubversiveSubstitute)')
-- map('x', 'P', '<Plug>(SubversiveSubstitute)')

require("mini.surround").setup()

local mini_diff = require('mini.diff')

mini_diff.setup()

-- todo: try this out to wrap rg: https://github.com/juniorsundar/cling.nvim

vim.keymap.set("n", "<leader>gdb", mini_diff.toggle_overlay, { desc = "Toggle diff buffer" })

require('mini.ai').setup({
  custom_textobjects = {
    b = {
      { '%b()', '%b[]', '%b{}', '%b""', "%b''" },
      '^.().*().$'
    },
  }
})

require("mini.cursorword").setup()

-- local statusline = require("mini.statusline")
-- statusline.setup({ use_icons = vim.g.have_nerd_font })
--
-- ---@diagnostic disable-next-line: duplicate-set-field
-- statusline.section_location = function()
--   return "%2l:%-2v"
-- end
--

-- I use mini.statusline relatively unchanged, the only thing I add is a little indicator for if we're viewing a
-- fugitive gitobject, because it can be hard to tell them apart from source files in the working tree.
local statusline = require("mini.statusline")

vim.api.nvim_set_hl(0, "StatuslineGitObject", { bg = "#ff0000", fg = "#ffffff", bold = true })

local function active_content()
  local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
  local git = statusline.section_git({ trunc_width = 40 })
  local diff = statusline.section_diff({ trunc_width = 75 })
  local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
  local lsp = statusline.section_lsp({ trunc_width = 75 })
  local filename = statusline.section_filename({ trunc_width = 140 })
  local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
  local location = "%2l:%-2v"

  local git_object = ""
  if vim.api.nvim_buf_get_name(0):match("^fugitive://") then
    git_object = "[GIT]"
  end

  return statusline.combine_groups({
    { hl = mode_hl,                 strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
    "%<",
    { hl = "MiniStatuslineFilename", strings = { filename } },
    "%=",
    { hl = "StatuslineGitObject",    strings = { git_object } },
    { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
    { hl = mode_hl,                  strings = { location } },
  })
end

statusline.setup({
  use_icons = vim.g.have_nerd_font,
  content = {
    active = active_content,
  },
})

-- local original_filename = statusline.section_filename
-- ---@diagnostic disable-next-line: duplicate-set-field
-- statusline.section_filename = function(args)
--   local bufname = vim.api.nvim_buf_get_name(0)
--   local prefix = bufname:match("^fugitive://") and "[GIT] " or ""
--   print(prefix)
--   return prefix .. original_filename(args)
-- end

require("nvim-treesitter.configs").setup {
  modules = {},
  sync_install = false,
  ignore_install = {},

  ensure_installed = {
    "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline",
    "query", "vim", "vimdoc", "elixir", "heex", "eex", "gleam", "rust",
    "tsx", "javascript", "typescript", "svelte", "css", "astro",
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "ruby" },
  },
  indent = { enable = true, disable = { "ruby" } },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
        ["aa"] = "@attribute.outer",
        ["ia"] = "@attribute.inner",
        ["ie"] = "@jsx_element.inner",
        ["ae"] = "@jsx_element.outer",
        ["ah"] = "@heex.outer",
      },
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V',
        ['@class.outer'] = '<c-v>',
      },
      include_surrounding_whitespace = true,
    },
  },
}

require 'treesitter-context'.setup {
  enable = true,
  multiwindow = false,
  max_lines = 1,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = 'outer',
  mode = 'cursor',
  separator = nil,
  zindex = 20,
  on_attach = nil,
}

-- LSP SETUP - RESOLVED CONFLICT: Use complete LSP setup from incoming branch
require("mason").setup()
require("fidget").setup()

local servers = {
  ["elixir-ls"] = {},
  lua_ls = {},
  ts_ls = {},
}

local ensure_installed = vim.tbl_keys(servers or {})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

-- Get capabilities for LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()

require("mason-lspconfig").setup({
  ensure_installed = {},
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
    map("grd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("<leader>k", vim.lsp.buf.hover, "Hover")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

    -- Inlay hints toggle
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has("nvim-0.11") == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

-- FZF-Lua setup
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
  oldfiles = vim.tbl_extend("force", ivy_profile.blines,
    { actions = defaults.globals.actions.files }
  ),
  files = ivy_profile.lines,
  jumps = ivy_profile.blines,
  grep = {
    rg_glob = false,
    rg_opts = " --color=always --column --line-number --no-heading --smart-case --max-columns=4096 -e",
  },
}

local function yank_selection()
  vim.cmd('normal! "vy')
  return vim.fn.getreg('v')
end

vim.keymap.set("v", "<leader>/", fzf.grep_visual, { desc = "Search project" })
vim.keymap.set("n", "<leader>/", fzf.grep_project, { desc = "Search project" })
vim.keymap.set("n", "<leader>h", fzf.help_tags, { desc = "Search help" })
vim.keymap.set("v", "<leader>h", function() fzf.help_tags({ query = yank_selection() }) end, { desc = "Search help" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("v", "<leader>fr", function() fzf.oldfiles({ query = yank_selection() }) end, { desc = "Recent files" })
vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Find files" })
vim.keymap.set("v", "<leader><leader>", function() fzf.files({ query = yank_selection() }) end, { desc = "Find files" })
vim.keymap.set("n", "<leader><cr>", fzf.resume, { desc = "Resume last search" })
vim.keymap.set("n", "<leader>ff", fzf.builtin, { desc = "Available pickers" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Diagnostics from document" })
vim.keymap.set("n", "<leader>fc", fzf.diagnostics_workspace, { desc = "Diagnostics from workspace" })

-- open vimrc / fzf the config directory
vim.keymap.set("n", "<leader>fv", function()
  vim.cmd("edit ~/.config/nvim/init.lua")
end, { desc = "Open vimrc" })

vim.keymap.set("n", "<leader>fV", function()
  fzf.files({
    cwd = "~/.config/nvim",
    winopts = { title = "Neovim Config" },
  })
end, { desc = "Search config directory" })

-- Git setup
vim.keymap.set("n", "<leader>gg", ":Git<cr>", { silent = true })
vim.keymap.set("n", "<leader>gb", ":Gitsigns blame<cr>", { silent = true })
vim.keymap.set("n", "<leader>ghs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "[H]unk stage" })
vim.keymap.set("n", "<leader>ghl", ":Gitsigns setqflist<cr>", { silent = true, desc = "Open [H]unk [L]ist for buffer" })
vim.keymap.set("n", "<leader>ghL", ":Gitsigns setqflist all<cr>",
  { silent = true, desc = "Open [H]unk [L]ist for repository" })

vim.keymap.set("n", "<leader>gsh", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "[S]tage hunk" })
vim.keymap.set("n", "<leader>gsb", ":Gitsigns stage_buffer<cr>", { silent = true, desc = "[S]tage buffer" })

vim.keymap.set("n", "<leader>gl", require("snacks").lazygit.log, { desc = "Lazygit log" })

-- run `:te git diff main`
vim.keymap.set("n", "<leader>gdd", ":te git diff --stat -p HEAD<cr>", { desc = "Git diff HEAD" })
vim.keymap.set("n", "<leader>gdm", ":te git diff --stat -p main...<cr>", { desc = "Git diff main..." })

-- run git status --short
-- vim.keymap.set("n", "<leader>gss", ":te git status --short<cr>", { silent = true, desc = "Git status --short" })
vim.keymap.set("n", "<leader>gss", function()
  print(vim.fn.system("git status --short"))
end, { silent = true, desc = "Git status --short" })
-- vim.keymap.set("n", "<leader>gss", function()
--   local output = vim.fn.system("git status --short")
--   local chunks = {}
--   for line in output:gmatch("[^\n]+") do
--     local status = line:sub(1, 2)
--     local hl = "Normal"
--     if status:match("^%?%?") then
--       hl = "DiagnosticWarn"
--     elseif status:match("^A") or status:match("^M") then
--       hl = "DiagnosticOk"
--     elseif status:match("^D") then
--       hl = "DiagnosticError"
--     elseif status:match("^ M") or status:match("^ D") then
--       hl = "DiagnosticInfo"
--     end
--     table.insert(chunks, { line .. "\n", hl })
--   end
--   vim.api.nvim_echo(chunks, false, {})
-- end, { silent = true, desc = "Git status --short" })

vim.cmd([[
  augroup FugitiveMappings
    autocmd!
    autocmd FileType fugitive nmap <buffer> <Tab> =
    autocmd User FugitiveObject setlocal bufhidden=
    " you could target the summary buffer like this but it doesn't work great
    "autocmd User FugitiveIndex setlocal bufhidden=
  augroup END
]])

-- set g:flog_enable_dynamic_branch_hl to false
-- vim.g.flog_enable_dynamic_branch_hl = false

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
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { follow_files = true },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 300,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  gh = true,
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

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

    map("n", "<leader>hp", gitsigns.preview_hunk)
    map("n", "<leader>hd", gitsigns.diffthis)
    map("n", "<leader>hD", function() gitsigns.diffthis("~") end)
    map("n", "<leader>td", gitsigns.toggle_deleted)
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})

require("nvim-lightbulb").setup({
  autocmd = { enabled = true }
})

require('mini.diff').setup()

-- AI/Codecompanion setup
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
          extended_thinking = { default = false },
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
    inline = { adapter = "anthropic" },
    cmd = { adapter = "anthropic" }
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
              lsp_client = { name = llm_role_title(request.data.adapter) },
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
            vim.api.nvim_del_augroup_by_name("CodeCompanionFidgetHooks")
          end
        }
      }
    }
  }
}

-- vim-test configuration
map("n", "<leader>tf", ":TestFile<cr>", { silent = true })
map("n", "<leader>tn", ":TestNearest<cr>", { silent = true })
map("n", "<leader>tl", ":TestLast<cr>", { silent = true })

vim.cmd [[
  function! BufferTermStrategy(cmd)
    exec 'te ' . a:cmd
  endfunction

  let g:test#custom_strategies = {'bufferterm': function('BufferTermStrategy')}
  let g:test#strategy = 'bufferterm'
]]

function PhoenixJumpFromClipboard()
  local clipboard = vim.fn.getreg "+"
  local pattern = "([%w%._/-]+%.%w+):(%d+)"
  local file_path, line_number = string.match(clipboard, pattern)

  if file_path and line_number then
    line_number = tonumber(line_number)
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
vim.keymap.set("n", "<leader>pj", PhoenixJumpFromClipboard, { desc = "Phoenix jump" })

vim.cmd.source("~/.config/nvim/ranger.vim")
map("n", "-", "<cmd>Ranger<CR>", { desc = "Open ranger" })

vim.cmd [[
  command! Messages enew | put = execute('messages')
]]

-- FINAL SECTION - RESOLVED CONFLICT: Include both flash and auto-hover features

-- Mini.files setup
require('mini.files').setup()

-- Flash setup with conservative settings
local disable_flash = {
  "quickfix", "loclist", "terminal", "prompt", "nofile", "help"
}

vim.keymap.set({ "n", "x", "o" }, "<enter>", function()
  local buftype = vim.bo.buftype
  if vim.tbl_contains(disable_flash, buftype) then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<enter>", true, false, true), "n", false)
  else
    require("flash").jump()
  end
end, { desc = "Flash" })

-- Auto-hover functionality (optional, starts disabled)
vim.pack.add({ "https://github.com/sj2tpgk/nvim-eldoc" })
require("nvim-eldoc").setup()

local auto_hover_enabled = false -- Start disabled to avoid noise
local lsp_hover_augroup = vim.api.nvim_create_augroup("LspHoverOnHold", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = lsp_hover_augroup,
  pattern = "*",
  callback = function()
    if not auto_hover_enabled then return end

    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients { bufnr = bufnr }

    local has_hover_provider = false
    for _, client in ipairs(clients) do
      if client and client.server_capabilities and client.server_capabilities.hoverProvider then
        has_hover_provider = true
        break
      end
    end

    if not has_hover_provider then return end

    local handler = function(err, result, _, _)
      if err or not result or not result.contents then return end
      local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      if vim.tbl_isempty(lines) then return end

      vim.lsp.util.open_floating_preview(lines, "markdown", {
        border = "rounded",
        relative = "editor",
        offset_x = vim.o.columns,
      })
    end

    local params = vim.lsp.util.make_position_params(0, "utf-32")
    vim.lsp.buf_request(bufnr, "textDocument/hover", params, handler)
  end,
})

-- Toggle function for auto-hover
local function toggle_auto_hover()
  auto_hover_enabled = not auto_hover_enabled
  local status = auto_hover_enabled and "enabled" or "disabled"
  vim.notify("Auto Hover " .. status, vim.log.levels.INFO, { title = "LSP" })
end

vim.keymap.set("n", "<leader>tah", toggle_auto_hover, { desc = "Toggle LSP auto hover" })

-- search changed lines in last n commits
local function search_changed_lines(num_commits)
  num_commits = num_commits or 5

  -- Get git diff with filenames and line numbers
  local cmd = string.format([[
    git log -p -U0 --no-merges -%d | awk '
      /^\+\+\+ b\// { file = substr($0, 7) }
      /^@@ / {
        if (match($0, /\+[0-9]+/)) {
          line_str = substr($0, RSTART+1, RLENGTH-1)
          line = line_str + 0
        }
      }
      /^[\+\-]/ && !/^([\+\-]){3}/ {
        print file ":" line ":" $0
        line++
      }
    '
  ]], num_commits)

  local handle = io.popen(cmd)
  if not handle then return end

  local result = handle:read('*a')
  handle:close()

  if result == '' then return end

  -- Split into lines
  local lines = {}
  for line in result:gmatch('[^\r\n]+') do
    table.insert(lines, line)
  end

  -- Get git root for building absolute paths
  local git_root_handle = io.popen('git rev-parse --show-toplevel')
  if not git_root_handle then return end
  local git_root = git_root_handle:read('*a'):gsub('%s+$', '')
  git_root_handle:close()

  -- Search through the lines with fzf
  fzf.fzf_exec(lines, {
    prompt = string.format('Changed lines in last %d commits> ', num_commits),
    actions = {
      ['default'] = function(selected)
        if not selected or #selected == 0 then return end

        -- Parse filename and line number from: "filename:line:+/- code"
        local filename, line_num = selected[1]:match('^(.-):(%d+):')
        if not filename or not line_num then return end

        -- Build absolute path and open file at line
        local abs_path = git_root .. '/' .. filename
        vim.cmd('edit ' .. vim.fn.fnameescape(abs_path))
        vim.cmd('normal! ' .. line_num .. 'G')
      end,
    },
  })
end

vim.api.nvim_create_user_command('SearchChangedLines', function(opts)
  local num_commits = tonumber(opts.args) or 5
  search_changed_lines(num_commits)
end, { nargs = '?' })

vim.keymap.set('n', '<leader>g/', function()
  search_changed_lines(5)
end, { desc = 'Search changed lines in last 5 commits' })

vim.api.nvim_create_user_command('CopyDiagnostics', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })

  if #diagnostics == 0 then
    print("No diagnostics on current line")
    return
  end

  local messages = {}
  for _, diag in ipairs(diagnostics) do
    table.insert(messages, diag.message)
  end

  local text = table.concat(messages, '\n')
  vim.fn.setreg('+', text)
  print("Copied " .. #diagnostics .. " diagnostic(s)")
end, {})

vim.api.nvim_create_user_command('CopyWithDiagnostics', function(opts)
  local line1 = opts.line1
  local line2 = opts.line2

  -- Get the code from the range
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
  local code = table.concat(lines, '\n')

  -- Get ALL diagnostics in the buffer
  local all_diagnostics = vim.diagnostic.get(0)

  -- Filter diagnostics to only those within the range
  local diag_messages = {}
  for _, diag in ipairs(all_diagnostics) do
    -- diag.lnum is 0-indexed, line1/line2 are 1-indexed
    if diag.lnum >= line1 - 1 and diag.lnum < line2 then
      local line_num = diag.lnum + 1
      table.insert(diag_messages, string.format("Line %d: %s", line_num, diag.message))
    end
  end

  -- Format the output
  local output = "code:\n" .. code

  if #diag_messages > 0 then
    output = output .. "\n\ndiagnostics:\n" .. table.concat(diag_messages, '\n')
  else
    output = output .. "\n\ndiagnostics:\n(none)"
  end

  -- Copy to clipboard
  vim.fn.setreg('+', output)
  print("Copied " .. (line2 - line1 + 1) .. " line(s) with " .. #diag_messages .. " diagnostic(s)")
end, { range = true })
