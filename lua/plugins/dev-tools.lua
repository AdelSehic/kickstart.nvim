vim.pack.add {
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/saecki/live-rename.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
}

-- [[ Linting ]]
local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}

-- To allow other plugins to add linters to require('lint').linters_by_ft,
-- instead set linters_by_ft like this:
-- lint.linters_by_ft = lint.linters_by_ft or {}
-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
--
-- However, note that this will enable a set of default linters,
-- which will cause errors unless these tools are available:
-- {
--   clojure = { "clj-kondo" },
--   dockerfile = { "hadolint" },
--   inko = { "inko" },
--   janet = { "janet" },
--   json = { "jsonlint" },
--   markdown = { "vale" },
--   rst = { "vale" },
--   ruby = { "ruby" },
--   terraform = { "tflint" },
--   text = { "vale" }
-- }
--
-- You can disable the default linters by setting their filetypes to nil:
-- lint.linters_by_ft['clojure'] = nil
-- lint.linters_by_ft['dockerfile'] = nil
-- lint.linters_by_ft['inko'] = nil
-- lint.linters_by_ft['janet'] = nil
-- lint.linters_by_ft['json'] = nil
-- lint.linters_by_ft['markdown'] = nil
-- lint.linters_by_ft['rst'] = nil
-- lint.linters_by_ft['ruby'] = nil
-- lint.linters_by_ft['terraform'] = nil
-- lint.linters_by_ft['text'] = nil

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- [[ Autoformat ]]
require('conform').setup {
  notify_on_error = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    --
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
}
vim.keymap.set('', '<F5>', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

require('trouble').setup {
  focus = true,
  win = {
    type = 'split',
    position = 'bottom',
  },
}

require('nvim-ts-autotag').setup {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
}

local live_rename = require 'live-rename'
live_rename.setup()
vim.keymap.set('n', '<leader>R', live_rename.map { insert = true }, { desc = 'LSP rename' })

local harpoon = require 'harpoon'
harpoon:setup()
vim.keymap.set("n", "<leader>ha", function () harpoon:list():add() end, { desc = "[H]arpoon [A]dd to list"})
vim.keymap.set("n", "<leader>hh", function () harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "[HH]arpoon show"})

vim.keymap.set("n", "<C-1>", function () harpoon:list():select(1) end)
vim.keymap.set("n", "<C-2>", function () harpoon:list():select(2) end)
vim.keymap.set("n", "<C-3>", function () harpoon:list():select(3) end)
vim.keymap.set("n", "<C-4>", function () harpoon:list():select(4) end)

-- [[ Undotree ]]
--  Nvim 0.12 ships its own undotree, see `:help :Undotree`
vim.cmd.packadd 'nvim.undotree'

local undodir = vim.fn.expand '~/.undotree'
vim.fn.mkdir(undodir, 'p')
vim.o.undodir = undodir
vim.o.undofile = true

vim.keymap.set('n', '<leader>u', vim.cmd.Undotree, { desc = 'Toggle [U]ndotree' })
