-- Uses nvim-treesitter (`plugins/treesitter.lua`) and mini.icons (`plugins/mini-nvim.lua`)
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
}
