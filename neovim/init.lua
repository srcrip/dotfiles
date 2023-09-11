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

-- Make sure leader is setup before loading lazy.nvim
vim.g.mapleader = " "

-- Then load the rest of settings
require('modules.settings')

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.opt.fillchars:append { diff = "╱" }

-- map('n', '<leader>r', vim.diagnostic.reset)
vim.keymap.set('n', '<space>r', vim.diagnostic.reset)

FOO = 'your_augroup_name'
vim.api.nvim_create_augroup(FOO, { clear = true })

require('lazy').setup({
  'sheerun/vim-polyglot',
  'svermeulen/vim-yoink',
  {
    'ojroques/nvim-bufdel',
    config = function()
      require('bufdel').setup {
        next = 'alternate'
      }
    end
  },
  'crusoexia/vim-monokai',
  'machakann/vim-sandwich',
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>m", require("grapple").toggle, {})

      vim.keymap.set("n", "<leader>j", function()
        require("grapple").select({ key = "{name}" })
      end, {})

      vim.keymap.set("n", "<leader>J", function()
        require("grapple").toggle({ key = "{name}" })
      end, {})


      vim.keymap.set("n", "<tab>", require("grapple").cycle_forward, {})
      vim.keymap.set("n", "<s-tab>", require("grapple").cycle_backward, {})
    end
  },
  { 'vladdoster/remember.nvim', config = [[ require('remember') ]] },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- You dont need to set any of these options. These are the default ones. Only
      -- the loading is important
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        }
      }
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')
    end
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
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
      -- to show diff splits and open commits in browser
      "tpope/vim-fugitive",
    },
  },
  { 'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require 'fzf-lua'.setup {
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
            vertical       = 'down:50%',      -- up|down:size
            horizontal     = 'right:50%',     -- right|left:size
          }
        }
      }

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
      -- map("v", "<space>/", ":FzfLua grep_project <C-R>=GetVisualSelection()<CR><CR>", { silent = true })
      map("v", "<space>/", ":lua require('fzf-lua').grep_visual()<cr>", { silent = true })
      map("n", "<space>/", ":FzfLua grep_project<cr>", { silent = true })
      map("n", "<space><space>", ":FzfLua grep_project<cr>", { silent = true })
      map("n", "<space>hh", ":FzfLua help_tags<cr>", { silent = true })
      map("n", "<space>fr", ":FzfLua oldfiles<cr>", { silent = true })
      map("n", "<space><space>", ":FzfLua files<cr>", { silent = true })
      map("n", "<space><cr>", ":FzfLua resume<cr>", { silent = true })
    end
  },
  {
    'junegunn/vim-easy-align',
    config = function()
      -- vim.cmd[[
      --   vmap ga <Plug>(EasyAlign)
      --   xmap ga <Plug>(EasyAlign)
      --   nmap ga <Plug>(EasyAlign)
      -- ]]
    end
  },
  {
    'svermeulen/vim-subversive',
    config = function()
      vim.cmd [[
        nmap s <Plug>(SubversiveSubstitute)
        nmap ss <Plug>(SubversiveSubstituteLine)
        nmap S <Plug>(SubversiveSubstituteToEndOfLine)
        xmap s <Plug>(SubversiveSubstitute)
        xmap p <Plug>(SubversiveSubstitute)
        xmap P <Plug>(SubversiveSubstitute)
      ]]
    end
  },
  {
    'notjedi/nvim-rooter.lua',
    config = function() require 'nvim-rooter'.setup() end
  },
  {
    "vim-test/vim-test",
    config = function()
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
    end
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
        }
      })
    end
  },
  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('nvim-lightbulb').setup({
          autocmd = {
            enabled = true,
          }
      })
    end
  },
  {
    "ray-x/lsp_signature.nvim",
  },
  -- TODO: Get one of these plugins working better?
  -- {
  --   "j-hui/fidget.nvim",
  --   config = function()
  --     require"fidget".setup{}
  --   end
  -- },
  -- {
  --   'nvim-lua/lsp-status.nvim',
  --   config = function()
  --     local lsp_status = require('lsp-status')
  --     lsp_status.config {
  --       status_symbol = '',
  --       diagnostics = false,
  --     }
  --   end
  -- },
  {
    "vigoux/notifier.nvim",
    config = function()
      require'notifier'.setup {
        ignore_messages = {}, -- Ignore message from LSP servers with this name
        components = {  -- Order of the components to draw from top to bottom (first nvim notifications, then lsp)
          "nvim",  -- Nvim notifications (vim.notify and such)
          "lsp"  -- LSP status updates
        },
        notify = {
          clear_time = 5000, -- Time in milliseconds before removing a vim.notify notification, 0 to make them sticky
          min_level = vim.log.levels.INFO, -- Minimum log level to print the notification
        },
        component_name_recall = false, -- Whether to prefix the title of the notification by the component name
        zindex = 50,
      }
    end
  },
  {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'lukas-reineke/lsp-format.nvim'
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'lukas-reineke/lsp-format.nvim',
      { 'j-hui/fidget.nvim', tag = "legacy", opts = {} },
    }
  },
  { "folke/neodev.nvim", opts = {} },
  'sindrets/diffview.nvim',
  'ntpeters/vim-better-whitespace',
  'iberianpig/tig-explorer.vim',
  'rbgrouleff/bclose.vim',
  -- todo: seems to have a bug with entering insert mode?
  -- {
  --   "NeogitOrg/neogit",
  --   dependencies = "nvim-lua/plenary.nvim",
  --   config = function()
  --     require("neogit").setup()
  --   end
  -- },
  {
    'tpope/vim-fugitive',
    config = function()
      map("n", "<space>gg", ":Git<cr>", { silent = true })
      vim.cmd [[
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
      ]]
    end
  },
  'tpope/vim-repeat',
  'tpope/vim-eunuch',
  -- 'tpope/vim-commentary',
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  'mg979/vim-visual-multi',
  {
    'mbbill/undotree',
    config = function()
      vim.cmd [[
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
      ]]
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end
  },
  {
    'nyngwang/murmur.lua',
    config = function()
      require('murmur').setup {
        max_len = 80,
        disable_on_lines = 1000,
        exclude_filetypes = {},
        callbacks = {
          -- to trigger the close_events of vim.diagnostic.open_float.
          function()
            -- Close floating diag. and make it triggerable again.
            vim.cmd('doautocmd InsertEnter')
            vim.w.diag_shown = false
          end,
        }
      }
      vim.api.nvim_create_autocmd('CursorHold', {
        group = FOO,
        pattern = '*',
        callback = function()
          -- skip when a float-win already exists.
          if vim.w.diag_shown then return end

          -- open float-win when hovering on a cursor-word.
          if vim.w.cursor_word ~= '' then
            vim.diagnostic.open_float(nil, {
              focusable = true,
              close_events = { 'InsertEnter' },
              border = 'rounded',
              source = 'always',
              prefix = ' ',
              scope = 'cursor',
            })
            vim.w.diag_shown = true
          end
        end
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        signs                        = {
          add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
          change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          untracked    = { hl = 'GitSignsAdd', text = '┆', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        },
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked          = true,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }
    end
  },
  {
    'glts/vim-textobj-comment',
    dependencies = {
      'kana/vim-textobj-user',
    },
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
          auto_install = true,
          highlight = { enable = false },
          -- textobjects = {
          --   select = {
          --     enable = true,
          --     lookahead = true,
          --     keymaps = {
          --       ['af'] = '@function.outer',
          --       ['if'] = '@function.inner',
          --       ['ac'] = '@comment.outer',
          --       ['ic'] = '@comment.inner',
          --     }
          --   }
          -- }
        }
    end,
  },
  'AndrewRadev/tagalong.vim',
  'nvim-tree/nvim-web-devicons',
  'feline-nvim/feline.nvim',
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup()
    end
  },
  {
    'zbirenbaum/copilot.lua',
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "right",
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<tab>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        ["."] = true,
      },
      copilot_node_command = '/Users/andrew/.asdf/installs/nodejs/16.18.1/bin/node',
      server_opts_overrides = {},
    }
  },
  {
    'akinsho/bufferline.nvim',
    config = function()
      require("bufferline").setup {
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
            bg = '#272822',
          },
          buffer_selected = {
            bg = '#272822'
          }
        }
      }
    end
  },
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
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitGutterAdd', text = '+' },
    change = { hl = 'GitGutterChange', text = '~' },
    delete = { hl = 'GitGutterDelete', text = '_' },
    topdelete = { hl = 'GitGutterDelete', text = '‾' },
    changedelete = { hl = 'GitGutterChange', text = '~' },
  },
}

function reload()
  for name, _ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)

  vim.notify("Configuration reloaded!", vim.log.levels.INFO)

  vim.api.nvim_command('PackerSync')
end

vim.cmd [[command! Reload lua reload()]]

vim.cmd [[
autocmd! TermOpen *FZF file term://fzf
autocmd! FileType fzf set laststatus=0 noshowmode noruler cmdheight=1
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler cmdheight=1 number signcolumn=yes
]]

vim.cmd [[colorscheme monokai]]

-- Reset scrolloff to 999 everytime a buffer is opened
-- Might be able to remove at some point, not sure what was overriding it
vim.cmd [[autocmd BufEnter * setlocal scrolloff=999]]

require('modules.files')
require('modules.buffers')
require('modules.clipboard')
require('modules.statusline')
require('modules.lsp')
require('modules.git_lens')
require('modules.terminals')
require('modules.fzf')
-- require('modules.autocomplete')
