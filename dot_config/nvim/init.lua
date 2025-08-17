-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd.source("~/.config/nvim/init.lua")
  vim.cmd.nohl()
end, { desc = "Reload config" })


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
-- vim.cmd("filetype plugin indent on")
-- vim.cmd("syntax enable")

function map(mode, key, action, opts)
  vim.keymap.set(mode, key, action, opts)
end

-- Normal mode mappings
map("n", "<ESC>", ":noh<CR><ESC>", { noremap = true, silent = true })
map("n", "gp", "`[v`]", { noremap = true })
map("n", "Q", "@q", { noremap = true })
map("n", "gj", "J", { noremap = true })
map("n", "<backspace>", "<c-^>", { noremap = true })
map("n", "<c-g>", ":let @+ = expand(\"%:p\") . \":\" . line(\".\") | echo 'copied ' . @+ . ' to the clipboard.'<CR>",
  { noremap = true })
map("n", "}", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"}\"<CR>", { noremap = true, silent = true })
map("n", "{", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"{\"<CR>", { noremap = true, silent = true })
map({ "n", "v" }, "J", "}", { noremap = true })
map({ "n", "v" }, "K", "{", { noremap = true })
map("n", "gf", "gF", { noremap = true })
map({ "n", "v" }, "H", "^", { noremap = true })
map({ "n", "v" }, "L", "$", { noremap = true })
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

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.pack.add({
  "file:///Users/marble/dev/ultrakai",
  -- "file:///Users/marble/dev/lookup.nvim",
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
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/kosayoda/nvim-lightbulb",
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/notjedi/nvim-rooter.lua"
})

vim.cmd('packadd lookup.nvim')
-- require("lookup.nvim").setup()

local lookup = require('lookup')
lookup.setup({
  use_lsp = true,    -- or false to disable LSP
  picker = 'fzf-lua' -- Options: 'telescope', 'fzf-lua', 'snacks', 'builtin'
})

vim.keymap.set("n", "gd", lookup.lookup_definition)

-- require("lookup").setup({
--   use_telescope = false,
--   use_fzf_lua = true
-- })

require('nvim-rooter').setup {
  rooter_patterns = { 'mix.exs', '.git' },
  trigger_patterns = { '*' },
  manual = false,
  fallback_to_parent = false,
  cd_scope = "global",
}

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

require("mini.cursorword").setup()

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
  ["elixir-ls"] = {
    -- root_dir = require("lspconfig.util").root_pattern("mix.exs", ".git"),
  },
  lua_ls = {},
  ts_ls = {},
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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

    -- Find references for the word under your cursor.
    -- map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    -- map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    -- map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    -- map("grd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
    map("grd", vim.lsp.buf.definition, "[G]oto [D]efinition")

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    -- map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    -- map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    -- map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

    map("<leader>k", vim.lsp.buf.hover, "Hover")

    map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has("nvim-0.11") == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if
        client
        and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
    then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})


local fzf = require("fzf-lua")
local ivy_profile = require("fzf-lua.profiles.ivy")

fzf.setup {
  "ivy",
  winopts = { preview = { default = "bat" }, treesitter = false },
  manpages = { previewer = "man_native" },
  helptags = { previewer = "help_native" },
  defaults = { git_icons = false, file_icons = false },
  lsp = { code_actions = { previewer = "codeaction_native" } },
  tags = { previewer = "bat" },
  btags = { previewer = "bat" },
  -- files = { fzf_opts = { ["--ansi"] = false } },
  files = ivy_profile.blines,
  oldfiles = ivy_profile.blines,
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
vim.keymap.set("n", "<space>gb", ":Git blame<CR>", { silent = true })

vim.cmd([[
  augroup FugitiveMappings
    autocmd!
    autocmd FileType fugitive nmap <buffer> <Tab> =

    " prevent fugitive buffers from being deleted when you leave them
    autocmd FileType fugitive set bufhidden=
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


-- Here be AI stuff
require("codecompanion").setup {
  strategies = {
    chat = {
      adapter = "anthropic",
    },
    inline = {
      adapter = "anthropic",
    },
    cmd = {
      adapter = "anthropic",
    }
  },
}

vim.cmd.source("~/.config/nvim/ranger.vim")
map("n", "-", "<cmd>Ranger<CR>", { desc = "Open ranger" })

---@type boolean
local auto_hover_enabled = true
-- vim.o.updatetime = 2000

vim.pack.add({ "https://github.com/sj2tpgk/nvim-eldoc" })

require("nvim-eldoc").setup()

local lsp_hover_augroup = vim.api.nvim_create_augroup("LspHoverOnHold", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = lsp_hover_augroup,
  pattern = "*",
  callback = function()
    if not auto_hover_enabled then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients { bufnr = bufnr }

    ---@type boolean
    local has_hover_provider = false
    for _, client in ipairs(clients) do
      if client and client.server_capabilities and client.server_capabilities.hoverProvider then
        has_hover_provider = true
        break
      end
    end

    if not has_hover_provider then
      return
    end

    local handler = function(err, result, _, _)
      if err or not result or not result.contents then
        return
      end

      local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

      if vim.tbl_isempty(lines) then
        return
      end

      vim.lsp.util.open_floating_preview(lines, "markdown", {
        border = "rounded",
        relative = "editor",
        offset_x = vim.o.columns,
      })
    end

    local params = vim.lsp.util.make_position_params(0, "utf-32")
    vim.lsp.buf_request(bufnr, "textDocument/hover", params, handler)
  end,
  desc = "Show LSP hover documentation on CursorHold (silently ignores empty responses)",
})

local function toggle_auto_hover()
  auto_hover_enabled = not auto_hover_enabled
  if auto_hover_enabled then
    vim.notify("Auto Hover enabled", vim.log.levels.INFO, { title = "LSP" })
  else
    vim.notify("Auto Hover disabled", vim.log.levels.INFO, { title = "LSP" })
  end
end

vim.keymap.set("n", "<leader><leader>Th", toggle_auto_hover,
  { desc = "Toggle LSP auto hover", noremap = false, silent = true })
