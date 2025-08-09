-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.o.shell = "/bin/bash"
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
-- vim.o.noswapfile = true
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
vim.o.winheight = 33

-- Folding settings
vim.o.foldenable = false
vim.o.foldmethod = "indent"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldtext = "getline(v:foldstart).'...'.trim(getline(v:foldend))"
vim.o.foldnestmax = 5
vim.o.foldminlines = 2

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
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

function map(mode, key, action, opts)
  vim.keymap.set(mode, key, action, opts)
end

-- Normal mode mappings
map("n", "<ESC>", ":noh<CR><ESC>", { noremap = true, silent = true })
map("n", "gp", "`[v`]", { noremap = true })
map("n", "Q", "@q", { noremap = true })
map("n", "gj", "J", { noremap = true })
map("n", "<backspace>", "<c-^>", { noremap = true })
map("n", "<c-g>", ":let @+ = expand(\"%:p\") . \":\" . line(\".\") | echo 'copied ' . @+ . ' to the clipboard.'<CR>", { noremap = true })
map("n", "}", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"}\"<CR>", { noremap = true, silent = true })
map("n", "{", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"{\"<CR>", { noremap = true, silent = true })
map("n", "J", "}", { noremap = true })
map("n", "K", "{", { noremap = true })
map("n", "gf", "gF", { noremap = true })
map("n", "H", "^", { noremap = true })
map("n", "L", "$", { noremap = true })
map("n", "j", "gj", { noremap = true })
map("n", "k", "gk", { noremap = true })

-- Visual mode mappings
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })

-- Autocommand for formatoptions
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.pack.add({
  "file:///Users/marble/dev/ultrakai",
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
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/mason-org/mason.nvim"
})

vim.cmd.colorscheme("ultrakai")

require("supermaven-nvim").setup {}

require("bufdel").setup { next = "alternate" }

require("which-key").setup {
  delay = 0,
  spec = {
    { "<leader>b",  group = "[B]uffers" },
    { "<leader>w",  group = "[W]indows" },
    { "<leader>f",  group = "[F]ind" },
    { "<leader>t",  group = "[T]oggle" },
    { "<leader>td", group = "[T]oggle [D]iagnostics" },
    { "<leader>h",  group = "Git [H]unk",            mode = { "n", "v" } },
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

local statusline = require("mini.statusline")

statusline.setup({ use_icons = vim.g.have_nerd_font })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

require("nvim-treesitter.configs").setup {
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
}

-- LSP setup
-- require("lspconfig").setup()
require("mason").setup()
require("fidget").setup()

local servers = {
  ["elixir-ls"] = {},
  lua_ls = {},
}

local ensure_installed = vim.tbl_keys(servers or {})

vim.list_extend(ensure_installed, {
  -- can use this to make sure mason installs stuff other than the lsp's above
  -- "stylua",
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
  ensure_installed = {}, -- explicitly set to an empty table (installs via mason-tool-installer instead)
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for ts_ls)
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
})


local fzf = require("fzf-lua")

fzf.setup()

vim.cmd [[
  function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)

    if len(lines) == 0
      return ""
    endif

    let lines[-1] = lines[-1][:column_end - (&selection == "inclusive" ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    return join(lines, "\n")
  endfunction
]]

vim.keymap.set("v", "<space>/", ":lua require('fzf-lua').grep_visual()<cr>", { silent = true })
vim.keymap.set("n", "<space>/", ":FzfLua live_grep<cr>", { silent = true })
vim.keymap.set("n", "<space>h", ":FzfLua help_tags<cr>", { silent = true })
vim.keymap.set("n", "<space>fr", ":FzfLua oldfiles<cr>", { silent = true })
vim.keymap.set("n", "<space><cr>", ":FzfLua resume<cr>", { silent = true })
vim.keymap.set("n", "<space><space>", ":FzfLua files<cr>", { silent = true })

-- load other modules
require("modules.settings")
require("modules.git_lens")

-- configure stuff not directly related to a plugin
vim.cmd.source("~/.config/nvim/ranger.vim")
map("n", "-", "<cmd>Ranger<CR>", { desc = "Open ranger" })
