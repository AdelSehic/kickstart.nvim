-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

vim.g.have_nerd_font = true

require 'opts'
require 'binds'
require 'user_commands'

-- [[ Plugins ]]
--  Plugins are managed by the built-in `vim.pack` plugin manager. See `:help vim.pack`
--
--  - Update plugins with `:PackUpdate`, review the changes, then `:write` to apply (or `:quit` to discard)
--  - Remove plugins that are no longer in the config with `:PackClean`
--  - Installed revisions are pinned in `nvim-pack-lock.json`, keep it under version control

-- Build hooks. These must be registered before `vim.pack.add()` installs the plugins.
--  See `:help vim.pack-events`
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-build-hooks', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    elseif name == 'nvim-dbee' then
      if not ev.data.active then
        vim.cmd.packadd { 'nvim-dbee', bang = true }
      end
      require('dbee').install()
    end
  end,
})

-- Order matters: the colorscheme comes first, mason (in `plugins.lsp`) must be set up
-- before anything that relies on the tools it installs.
require 'plugins.ui-plugins'
require 'plugins.mini-nvim'
require 'plugins.which-key'
require 'plugins.gitsigns'
require 'plugins.fzf'
require 'plugins.lsp'
require 'plugins.blink'
require 'plugins.treesitter'
require 'plugins.dev-tools'
require 'plugins.debug'
require 'plugins.lualine'
require 'plugins.markdown'
require 'plugins.neo-tree'
require 'plugins.dbee'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
