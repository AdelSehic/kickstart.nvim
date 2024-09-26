return {
  -- :Telescope colorscheme`.
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
    opts = {
      check_ts = true,
    },
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'hadronized/hop.nvim',
    cmd = { 'HopWord' },
    opts = {
      keys = { 'etovxqpdygfblzhckisuran' },
    },
    init = function()
      require('hop').setup()
    end,
  },
  {
    'stevearc/dressing.nvim',
    event = 'User BaseDefered',
    opts = {
      input = { default_prompt = '➤ ' },
      select = { backend = { 'telescope', 'builtin' } },
    },
  },
  -- lazy.nvim
  -- {
  --   'folke/noice.nvim',
  --   -- event = 'VeryLazy',
  --   opts = {
  --     lsp = {
  --       -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --       override = {
  --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
  --         ['vim.lsp.util.stylize_markdown'] = true,
  --         ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
  --       },
  --     },
  --     -- you can enable a preset for easier configuration
  --     presets = {
  --       bottom_search = true, -- use a classic bottom cmdline for search
  --       command_palette = true, -- position the cmdline and popupmenu together
  --       long_message_to_split = true, -- long messages will be sent to a split
  --       inc_rename = true, -- enables an input dialog for inc-rename.nvim
  --       lsp_doc_border = false, -- add a border to hover docs and signature help
  --     },
  --   },
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   init = function()
  --     require('noice').setup {
  --       views = {
  --         cmdline_popup = {
  --           position = {
  --             row = 5,
  --             col = '50%',
  --           },
  --           size = {
  --             width = 60,
  --             height = 'auto',
  --           },
  --         },
  --         popupmenu = {
  --           relative = 'editor',
  --           position = {
  --             row = 8,
  --             col = '50%',
  --           },
  --           size = {
  --             width = 60,
  --             height = 10,
  --           },
  --           border = {
  --             style = 'rounded',
  --             padding = { 0, 1 },
  --           },
  --           win_options = {
  --             winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
  --           },
  --         },
  --       },
  --
  --       -- @recording in notification box
  --       routes = {
  --         {
  --           view = 'notify',
  --           filter = { event = 'msg_showmode' },
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      autochdir = true,
      direction = 'float',
      float_opts = {
        border = 'curved',
        winblend = 0,
      }
    }
  }
}
