return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},
    config = function()
      local fzf = require 'fzf-lua'

      vim.keymap.set('n', '<leader>sf', fzf.files,            { desc = "[S]earch [F]iles" })
      vim.keymap.set('n', '<leader>fh', fzf.oldfiles,         { desc = "[F]ile [H]istory" })
      vim.keymap.set('n', '<leader>sr', fzf.resume,           { desc = "[S]earch [R]esume" })
      vim.keymap.set('n', '<leader>sqf', fzf.quickfix,        { desc = "[S]earch [Q]uick [F]ixes" })
      vim.keymap.set('n', '<leader>st', fzf.treesitter,       { desc = "[S]earch [T]reesitter" })
      vim.keymap.set('n', '<leader>sg', fzf.live_grep_native, { desc = "[S]earch [G]REP" })
      vim.keymap.set('n', '<leader>sb', fzf.lgrep_curbuf,     { desc = "[S]earch [B]uffer" })
      vim.keymap.set('n', '<leader>sw', fzf.grep_cword,       { desc = "[S]earch [W]ord" })
      vim.keymap.set('n', '<leader>gd', fzf.grep_cword,       { desc = "[S]earch [G]it [D]iff" })

      -- LSP keymaps
      vim.keymap.set('n', 'gr', fzf.lsp_references,       { desc = "[G]oto [R]eferences" })
      vim.keymap.set('n', 'gd', fzf.lsp_definitions,      { desc = "[G]oto [D]efinitions" })
      vim.keymap.set('n', 'gD', fzf.lsp_typedefs,         { desc = "[G]oto Type[D]ef" })
      vim.keymap.set('n', 'gi', fzf.lsp_implementations,  { desc = "[G]oto [I]mplementations" })

      vim.keymap.set('n', '<leader>ca', fzf.lsp_code_actions,           { desc = "[C]ode [A]ctions" })
      vim.keymap.set('n', '<leader>cci', fzf.lsp_incoming_calls,        { desc = "[C]ode [C]alls [I]ncoming" })
      vim.keymap.set('n', '<leader>cco', fzf.lsp_outgoing_calls,        { desc = "[C]ode [C]alls [O]outgoing" })
      vim.keymap.set('n', '<leader>cdd', fzf.lsp_document_diagnostics,  { desc = "[C]ode [D]iagnostics [D]ocument" })
      vim.keymap.set('n', '<leader>cdw', fzf.lsp_workspace_diagnostics, { desc = "[C]ode [D]iagnostics [W]orkspace" })
    end
  },
}
