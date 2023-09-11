-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.o.shell = "/bin/bash"

-- Then load the rest of settings
require("modules.settings")

function map(mode, keys, func, opts)
  local options = { noremap = true }

  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  vim.keymap.set(mode, keys, func, options)
end

vim.opt.fillchars:append({ diff = "╱" })

require("lazy").setup({
  "sheerun/vim-polyglot",
  "svermeulen/vim-yoink",
  {
    "ojroques/nvim-bufdel",
    config = function()
      require("bufdel").setup({
        next = "alternate",
      })
    end,
  },
  "crusoexia/vim-monokai",
  "machakann/vim-sandwich",
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- {
  --   "elixir-tools/elixir-tools.nvim",
  --   version = "*",
  --   event = { "BufReadPre", "BufNewFile" },
  --   config = function()
  --     local elixir = require("elixir")
  --     local elixirls = require("elixir.elixirls")
  --
  --     elixir.setup {
  --       nextls = { enable = true },
  --       credo = {},
  --       elixirls = {
  --         enable = true,
  --         settings = elixirls.settings {
  --           dialyzerEnabled = false,
  --           enableTestLenses = false,
  --         },
  --         on_attach = function(client, bufnr)
  --           vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
  --           vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
  --           vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
  --         end,
  --       }
  --     }
  --   end,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  -- },
  -- {
  --   'crusj/bookmarks.nvim',
  --   keys = {
  --     { "<tab><tab>", mode = { "n" } },
  --   },
  --   branch = 'main',
  --   dependencies = { 'nvim-web-devicons' },
  --   config = function()
  --     require("bookmarks").setup({
  --       mappings_enabled = true,
  --       keymap = {
  --         toggle = "<tab><tab>", -- Toggle bookmarks(global keymap)
  --         add = "\\z", -- Add bookmarks(global keymap)
  --         jump = "<CR>", -- Jump from bookmarks(buf keymap)
  --         delete = "dd", -- Delete bookmarks(buf keymap)
  --         order = "<space><space>", -- Order bookmarks by frequency or updated_time(buf keymap)
  --         delete_on_virt = "\\dd", -- Delete bookmark at virt text line(global keymap)
  --         show_desc = "\\sd", -- show bookmark desc(global keymap)
  --       },
  --       width = 0.8, -- Bookmarks window width:  (0, 1]
  --       height = 0.6, -- Bookmarks window height: (0, 1]
  --       preview_ratio = 0.4, -- Bookmarks preview window ratio (0, 1]
  --       preview_ext_enable = false, -- If true, preview buf will add file ext, preview window may be highlighed(treesitter), but may be slower.
  --       fix_enable = false, -- If true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.

  --       virt_text = "BOOKMARK", -- Show virt text at the end of bookmarked lines
  --       virt_pattern = { "*" }, -- Show virt text only on matched pattern
  --       border_style = "single", -- border style: "single", "double", "rounded"
  --       hl = {
  --         border = "TelescopeBorder", -- border highlight
  --         cursorline = "guibg=Gray guifg=White", -- cursorline highlight
  --       }
  --     })
  --     require("telescope").load_extension("bookmarks")
  --   end
  -- },
  -- {
  --   "cbochs/grapple.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     vim.keymap.set("n", "<leader>m", require("grapple").toggle, {})

  --     vim.keymap.set("n", "<leader>j", function()
  --       require("grapple").select({ key = "{name}" })
  --     end, {})

  --     vim.keymap.set("n", "<leader><backspace>", function()
  --       require("grapple").popup_tags()
  --     end, {})

  --     vim.keymap.set("n", "<leader>J", function()
  --       require("grapple").toggle({ key = "{name}" })
  --     end, {})

  --     -- vim.keymap.set("n", "<leader><tab>", function()
  --     --   require("grapple").tag()
  --     -- end, {})

  --     -- vim.keymap.set("n", "<leader><s-tab>", function()
  --     --   require("grapple").untag()
  --     -- end, {})

  --     vim.keymap.set("n", "<tab>", require("grapple").cycle_forward, {})
  --     vim.keymap.set("n", "<s-tab>", require("grapple").cycle_backward, {})
  --   end
  -- },
  { "vladdoster/remember.nvim", config = [[ require('remember') ]] },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    config = function()
      map("n", "]q", ":cn<cr>", { silent = true })
      map("n", "[q", ":cp<cr>", { silent = true })
    end
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    config = function()
      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-fugitive",
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        -- fzf_opts = {
        --   -- options are sent as `<left>=<right>`
        --   -- set to `false` to remove a flag
        --   -- set to '' for a non-value flag
        --   -- for raw args use `fzf_args` instead
        --   ['--ansi']           = '',
        --   ['--info']           = 'inline',
        --   ['--height']         = '100%',
        --   ['--layout']         = 'reverse',
        --   ['--border']         = 'none',
        --   ['--preview-window'] = 'nohidden,down,20%'
        -- },
        winopts = {
          preview = {
            vertical = "down:50%",    -- up|down:size
            horizontal = "right:50%", -- right|left:size
          },
        },
      })

      vim.cmd([[
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
      ]])
      map("v", "<space>/", ":lua require('fzf-lua').grep_visual()<cr>", { silent = true })
      map("n", "<space>/", ":FzfLua grep_project<cr>", { silent = true })
      map("n", "<space><space>", ":FzfLua grep_project<cr>", { silent = true })
      map("n", "<space>hh", ":FzfLua help_tags<cr>", { silent = true })
      map("n", "<space>fr", ":FzfLua oldfiles<cr>", { silent = true })
      map("n", "<space><space>", ":FzfLua files<cr>", { silent = true })
      map("n", "<space><cr>", ":FzfLua resume<cr>", { silent = true })
    end,
  },
  {
    "svermeulen/vim-subversive",
    config = function()
      vim.cmd([[
        nmap s <Plug>(SubversiveSubstitute)
        nmap ss <Plug>(SubversiveSubstituteLine)
        nmap S <Plug>(SubversiveSubstituteToEndOfLine)
        xmap s <Plug>(SubversiveSubstitute)
        xmap p <Plug>(SubversiveSubstitute)
        xmap P <Plug>(SubversiveSubstitute)
      ]])
    end,
  },
  {
    "notjedi/nvim-rooter.lua",
    config = function()
      require("nvim-rooter").setup()
    end,
  },
  {
    "vim-test/vim-test",
    config = function()
      map("n", "<space>tf", ":TestFile<cr>", { silent = true })
      map("n", "<space>tn", ":TestNearest<cr>", { silent = true })
      map("n", "<space>tl", ":TestLast<cr>", { silent = true })

      vim.cmd([[
        function! BufferTermStrategy(cmd)
          exec 'te ' . a:cmd
        endfunction

        let g:test#custom_strategies = {'bufferterm': function('BufferTermStrategy')}
        let g:test#strategy = 'bufferterm'
      ]])
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "jfpedroza/neotest-elixir",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-elixir"),
        },
      })
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    dependencies = "antoinemadec/FixCursorHold.nvim",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = {
          enabled = true,
        },
      })
    end,
  },
  {
    "vigoux/notifier.nvim",
    config = function()
      require("notifier").setup({
        ignore_messages = {}, -- Ignore message from LSP servers with this name
        components = {        -- Order of the components to draw from top to bottom (first nvim notifications, then lsp)
          "nvim",             -- Nvim notifications (vim.notify and such)
          "lsp",              -- LSP status updates
        },
        notify = {
          clear_time = 5000,               -- Time in milliseconds before removing a vim.notify notification, 0 to make them sticky
          min_level = vim.log.levels.INFO, -- Minimum log level to print the notification
        },
        component_name_recall = false,     -- Whether to prefix the title of the notification by the component name
        zindex = 50,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { 'folke/neodev.nvim', lazy = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
    }
  },
  {
    "jay-babu/mason-null-ls.nvim",
    cmd = { "NullLsInstall", "NullLsUninstall" },
    opts = {
      automatic_setup = true,
      ensure_installed = {
        "stylua",
        "dprint",
        "prettierd",
        "eslint_d"
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { "WhoIsSethDaniel/lualine-lsp-progress.nvim" },
    config = function()
      local lualine = require('lualine')

      local theme = require 'lualine.themes.modus-vivendi'
      theme.normal.c.bg = '#272822'
      theme.insert.c.bg = '#272822'
      theme.visual.c.bg = '#272822'
      theme.replace.c.bg = '#272822'
      theme.command.c.bg = '#272822'
      theme.inactive.c.bg = '#272822'

      local lsp_servers = require('lualine.component'):extend()

      function lsp_servers:init(options)
        options.icon = options.icon or "󰌘"
        options.separator = options.separator or " "
        options.color = { fg = '#ffaa88', gui = 'italic,bold' }
        options.padding = 0
        lsp_servers.super.init(self, options)
      end

      function lsp_servers:update_status()
        local buf_clients = vim.lsp.get_active_clients()
        local null_ls_installed, null_ls = pcall(require, "null-ls")
        local buf_client_names = {}
        for _, client in pairs(buf_clients) do
          if client.name == "null-ls" then
            if null_ls_installed then
              for _, source in ipairs(null_ls.get_source({ filetype = vim.bo.filetype })) do
                table.insert(buf_client_names, source.name)
              end
            end
          else
            table.insert(buf_client_names, client.name)
          end
        end
        return table.concat(buf_client_names, self.options.separator)
      end

      lualine.setup {
        options = {
          icons_enabled = false,
          theme = theme,
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff' },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = false,
              path = 1,
              -- Shortens path to leave 40 spaces in the window
              shorting_target = 40,
              symbols = {
                modified = '(modified)',
                readonly = '(readonly)',
                unnamed = '[No Name]',
                newfile = '[New]'
              }
            }
          },
          lualine_x = {
            {
              'diagnostics',
              sections = { 'error', 'warn', 'info', 'hint' },

              diagnostics_color = {
                -- Same values as the general color option can be used here.
                error = 'DiagnosticError',
                warn  = 'DiagnosticWarn',
                info  = 'DiagnosticInfo',
                hint  = 'DiagnosticHint',
              },
              symbols = { error = 'Err ', warn = 'Warn ', info = 'Info ', hint = 'Hint ' },
              colored = true,
              update_in_insert = false,
              always_visible = false
            },
            lsp_servers,
            {
              'filetype',
              colored = true,
              padding = { left = 0, right = 1 },
              icon = { align = 'right' },
            },
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        winbar = {
          -- lualine_a = {},
          lualine_b = {
            {
              "navic",
              color_correction = nil,
              navic_opts = nil,
              color = { bg = "#272822", fg = '#949494' }
            }
          },
          -- lualine_c = {
          -- },
          --   lualine_x = {},
          --   lualine_y = {},
          --   lualine_z = {}
        },
        inactive_winbar = {
          --   lualine_a = {},
          --   lualine_b = {},
          lualine_c = {
            {
              'filename',
              color = { fg = '#8c8c89', gui = 'italic,bold' },
              file_status = true,
              newfile_status = false,
              path = 1,
              shorting_target = 40,
              symbols = {
                modified = '(modified)',
                readonly = '(readonly)',
                unnamed = '[No Name]',
                newfile = '[New]'
              }
            } },
          --   lualine_x = {},
          --   lualine_y = {},
          --   lualine_z = {}
        },
      }
    end
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    opts = {}
  },
  -- WARNING: null-ls.nvim will be archived on August 11, 2023
  -- Find a suitable replacement soon
  -- Related: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1621
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local nls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      return {
        sources = {
          -- nls.builtins.formatting.dprint,
          nls.builtins.formatting.prettierd,
        },
        on_attach = function(client, bufnr)
          vim.notify("attaching null_ls")
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*" },
            callback = function(_)
              vim.lsp.buf.format()
            end
          })
        end,
      }
    end,
  },

  { "folke/neodev.nvim",        opts = {} },
  "sindrets/diffview.nvim",
  "ntpeters/vim-better-whitespace",
  "iberianpig/tig-explorer.vim",
  "rbgrouleff/bclose.vim",
  {
    "tpope/vim-fugitive",
    config = function()
      map("n", "<space>gg", ":Git<cr>", { silent = true })
      vim.cmd([[
        au FileType gitcommit execute "normal! O" | startinsert
        nnoremap <silent> <space>gd :Gdiff<CR>
        nnoremap <silent> <space>gb :Git blame<CR>
        nnoremap <silent> <space>gL :Git log --author=sevensidedmarble <CR>
        nnoremap <silent> <space>gl :Git log<CR>
        nnoremap <silent> <space>gb :GBranches! checkout<CR>
        nnoremap <silent> <space>gc :GBranches! create<CR>
        nnoremap <silent> <space>G :Tig<CR>

        augroup FugitiveMappings
          autocmd!
          " autocmd FileType fugitive setlocal winheight=40 | nmap <buffer> <Tab> =
          autocmd FileType fugitive nmap <buffer> <Tab> =
        augroup END
      ]])
    end,
  },
  'tpope/vim-repeat',
  'tpope/vim-eunuch',
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  "mg979/vim-visual-multi",
  {
    "mbbill/undotree",
    config = function()
      vim.cmd([[
        nmap U <C-r>
        nnoremap <c-\> :UndotreeToggle<cr>
        let g:undotree_WindowLayout = 4
        let g:undotree_SplitWidth = 25
        let g:undotree_SetFocusWhenToggle = 1
        let g:undotree_HelpLine = 0
        let g:undotree_HighlightChangedText = 0
        let g:undotree_ShortIndicators = 1
        set undofile
        set undodir=~/.config/nvim/undo
        set undolevels=10000
        set undoreload=10000
      ]])
    end,
  },
  -- {
  --   "kelly-lin/ranger.nvim",
  --   config = function()
  --     require("ranger-nvim").setup({
  --       replace_netrw = true,
  --       enable_cmds = true,
  --       ui = {
  --         border = "rounded",
  --         height = 0.8,
  --         width = 0.8,
  --         x = 0.5,
  --         y = 0.5,
  --       }
  --     })
  --     vim.api.nvim_set_keymap("n", "-", "", {
  --         noremap = true,
  --         callback = function()
  --           require("ranger-nvim").open(true)
  --         end,
  --       })
  --   end,
  -- },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end,
  },
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.cursorword').setup({ delay = 50 })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = {
            hl = "GitSignsChange",
            text = "│",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          delete = {
            hl = "GitSignsDelete",
            text = "_",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          topdelete = {
            hl = "GitSignsDelete",
            text = "‾",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          changedelete = {
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
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
      })
    end
  },
  {
    'glts/vim-textobj-comment',
    dependencies = {
      'kana/vim-textobj-user',
    },
  },
  { 'RRethy/nvim-treesitter-endwise' },
  {
    'windwp/nvim-ts-autotag',
    opts = {
      filetypes = {
        'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
        'rescript',
        'xml',
        'php',
        'markdown',
        'astro', 'glimmer', 'handlebars', 'hbs',
        'elixir', 'eelixir', 'heex'
      }
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c',
          'cpp',
          'elixir',
          'eex',
          'go',
          'rust',
          'tsx',
          'typescript',
          'help',
          'diff',
          'vim',
          'regex',
          'lua',
          'bash',
          'markdown',
          'markdown_inline'
        },
        endwise = {
          enable = true,
        },
        auto_install = true,
        highlight = { enable = false },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "cpp",
          "elixir",
          "go",
          "rust",
          "tsx",
          "typescript",
          -- 'help',
          "diff",
          "vim",
          "regex",
          "lua",
          "bash",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        highlight = { enable = false },
        indent = { enable = true },
      })
    end,
  },
  "AndrewRadev/tagalong.vim",
  "nvim-tree/nvim-web-devicons",
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 50,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false
        },
      },
      filetypes = {
        ["."] = true,
      },
      copilot_node_command = "node",
      server_opts_overrides = {},
    },
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          show_buffer_close_icons = false,
          show_close_icon = false,
          custom_filter = function(buf_number)
            -- filter out quickfix
            if vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
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
      })
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'windwp/nvim-autopairs',
      'FelipeLema/cmp-async-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'saadparwaiz1/cmp_luasnip',
      {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        version = 'v2.*',
        config = true,
        keys = {
          -- {
          --   '<c-space>',
          --   function()
          --     return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
          --   end,
          --   expr = true,
          --   silent = true,
          --   mode = 'i',
          -- },
          -- {
          --   '<tab>',
          --   function()
          --     return require('luasnip').jump(1)
          --   end,
          --   mode = 's',
          -- },
          -- {
          --   '<S-tab>',
          --   function()
          --     return require('luasnip').jump(-1)
          --   end,
          --   mode = { 'i', 's' },
          -- },
        },
      },
    },
    event = 'InsertEnter',
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require('cmp')
      local defaults = require('cmp.config.default')()

      return {
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        -- preselect = cmp.PreselectMode.Item,
        preselect = cmp.PreselectMode.None,
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
        }),
        performance = {
          max_view_entries = 5
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          -- { name = 'buffer' },
          { name = 'async_path' },
          { name = 'nvim_lsp_signature_help' },
        }),
        -- formatting = {
        --   format = function(_, item)
        --     local icons = {
        --       Array = ' ',
        --       Boolean = ' ',
        --       Class = ' ',
        --       Color = ' ',
        --       Constant = ' ',
        --       Constructor = ' ',
        --       Copilot = ' ',
        --       Enum = ' ',
        --       EnumMember = ' ',
        --       Event = ' ',
        --       Field = ' ',
        --       File = ' ',
        --       Folder = ' ',
        --       Function = ' ',
        --       Interface = ' ',
        --       Key = ' ',
        --       Keyword = ' ',
        --       Method = ' ',
        --       Module = ' ',
        --       Namespace = ' ',
        --       Null = ' ',
        --       Number = ' ',
        --       Object = ' ',
        --       Operator = ' ',
        --       Package = ' ',
        --       Property = ' ',
        --       Reference = ' ',
        --       Snippet = ' ',
        --       String = ' ',
        --       Struct = ' ',
        --       Text = ' ',
        --       TypeParameter = ' ',
        --       Unit = ' ',
        --       Value = ' ',
        --       Variable = ' ',
        --     }
        --     if icons[item.kind] then
        --       item.kind = icons[item.kind] .. item.kind
        --     end
        --     return item
        --   end,
        -- },
        experimental = {
          -- ghost_text = { hl_group = 'CmpGhostText' }
          -- native_menu = false,
          ghost_text = false,
        },
        sorting = defaults.sorting,
        window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
      }
    end,
    config = function(_, opts)
      local cmp = require('cmp')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.setup(opts)
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } },
      })
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' }, { name = 'cmdline' } }),
      })
      -- nvim-autopairs integration
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      -- gray
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
      -- blue
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
      -- light blue
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
      vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
      vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
      -- pink
      vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
      vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
      -- front
      vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
      vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

      --- If copilot suggestion is visible and cmp has no selected entry,
      --- <CR> will accept suggestion, otherwise if there is no
      --- copilot suggestion and cmp is visible, <CR> will select
      --- the first cmp entry, otherwise <CR> will just do
      --- its default behavior.
      vim.keymap.set("i", "<TAB>", function()
        local suggestion = require("copilot.suggestion")
        if
            cmp
            and (
              cmp.visible() and cmp.get_selected_entry() ~= nil
              or cmp.visible() and (not suggestion or not suggestion.is_visible())
            )
        then
          vim.defer_fn(function() cmp.confirm({ select = true }) end, 5)
          return true
        end
        if suggestion and suggestion.is_visible() then
          vim.defer_fn(function() suggestion.accept() end, 5)
          return true
        end
        return "<TAB>"
      end, { expr = true, remap = true })
    end
  }
})

-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

-- Gitsigns
require("gitsigns").setup({
  signs = {
    add = { hl = "GitGutterAdd", text = "+" },
    change = { hl = "GitGutterChange", text = "~" },
    delete = { hl = "GitGutterDelete", text = "_" },
    topdelete = { hl = "GitGutterDelete", text = "‾" },
    changedelete = { hl = "GitGutterChange", text = "~" },
  },
})

vim.cmd([[
autocmd! TermOpen *FZF file term://fzf
autocmd! FileType fzf set laststatus=0 noshowmode noruler cmdheight=1
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler cmdheight=1 number signcolumn=yes
]])

vim.cmd([[colorscheme monokai]])

-- moving around buffers and stuff
vim.cmd [[
function! ToggleWindowHorizontalVerticalSplit()
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

  com! Rotate :call ToggleWindowHorizontalVerticalSplit()<cr>

  nnoremap <silent> <c-x><c-k> :BufDel!<CR>
  nnoremap <silent> <leader><q> :BufDel!<CR>
  nmap <silent> <c-h> :BufferLineCyclePrev<CR>
  nmap <silent> <c-l> :BufferLineCycleNext<CR>
  nmap <silent> <c-x><c-s> :w<CR>
  nmap <silent> <c-x><c-b> :FzfLua buffers<CR>

  function! CloseAllOtherBuffers()
    let curr = bufnr("%")
    let last = bufnr("$")

    if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
    if curr < last | silent! execute (curr+1).",".last."bd" | endif
  endfunction

  com! BufOnly execute 'call CloseAllOtherBuffers()'
  nmap <silent> <space>bo :BufOnly<CR>
]]

-- files
vim.cmd [[
  source ~/.config/nvim/ranger.vim
  nmap <silent> - :Ranger<cr>
]]

-- clipboard
vim.cmd [[
  set clipboard=unnamedplus
  let g:yoinkSyncNumberedRegisters = 1
  let g:yoinkIncludeDeleteOperations = 1
  let g:yoinkAutoFormatPaste = 1
  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)
  nmap <c-p> <plug>(YoinkPostPasteSwapBack)
  nmap <c-n> <plug>(YoinkPostPasteSwapForward)
  nmap y <plug>(YoinkYankPreserveCursorPosition)
  xmap y <plug>(YoinkYankPreserveCursorPosition)
  nmap Y y$
]]

require("modules.statusline")
require("modules.git_lens")
require("modules.lsp")
require("modules.fzf")
require("modules.terminals")

vim.api.nvim_set_hl(0, "DiffText", { bg = "#6068da" })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "#272822", fg = '#949494' })
