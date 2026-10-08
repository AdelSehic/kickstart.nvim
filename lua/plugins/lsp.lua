-- [[ LSP ]]
--  Servers are configured with the built-in `vim.lsp.config()` and started with `vim.lsp.enable()`.
--  `nvim-lspconfig` only provides the default server configs (the `lsp/*.lua` files), and mason
--  installs the server binaries. See `:help lsp-config` and `:help lsp-quickstart`
--
--  If you're wondering about lsp vs treesitter, you can check out the wonderfully
--  and elegantly composed help section, `:help lsp-vs-treesitter`

vim.pack.add {
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  'https://github.com/folke/lazydev.nvim',

  -- Default configs for the language servers
  'https://github.com/neovim/nvim-lspconfig',

  -- Automatically install LSPs and related tools to stdpath for Neovim
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

  -- Useful status updates for LSP.
  'https://github.com/j-hui/fidget.nvim',
}

-- Nvim 0.12 ships the `vim.uv` type annotations, so luvit-meta is no longer needed
require('lazydev').setup {}

require('fidget').setup {}

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
--
--  NOTE: Nvim already creates these LSP keymaps by default, see `:help lsp-defaults`
--    `grn` rename, `gra` code action, `grr` references, `gri` implementation, `grt` type definition,
--    `gO` document symbols, `K` hover, `<C-s>` (insert mode) signature help
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buf = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ds', require('fzf-lua').lsp_document_symbols, '[D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ws', require('fzf-lua').lsp_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor is done with live-rename (`<leader>R`), see `plugins/dev-tools.lua`

    -- Execute a code action on the selected range. In normal mode `<leader>ca` uses fzf-lua, see `plugins/fzf.lua`
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', 'x')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    --  (`gD` is goto type definition, see `plugins/fzf.lua`)
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buf = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buf = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buf = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- LSP capabilities: blink.cmp adds its completion capabilities to every server on its own
-- (through `vim.lsp.config('*', ...)`), and the folding ranges nvim-ufo needs are part of
-- Nvim's default client capabilities.

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They are passed to
--  `vim.lsp.config()` and merged on top of the nvim-lspconfig defaults. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--  See `:help vim.lsp.Config` for everything else.
local lua_workspace_library = {}
if vim.fn.isdirectory('/usr/share/hypr/stubs') == 1 then
  table.insert(lua_workspace_library, '/usr/share/hypr/stubs')
end

-- Markers in the same (nested) list have equal priority, so the closest one wins
local lua_root_markers = {
  { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
}
local hypr_config_dir = vim.fs.normalize(vim.fn.expand '~/.config/hypr')

---@type table<string, vim.lsp.Config>
local servers = {
  -- clangd = {},
  gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},
  --

  lua_ls = {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    root_dir = function(bufnr, on_dir)
      local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
      if path == hypr_config_dir or path:sub(1, #hypr_config_dir + 1) == hypr_config_dir .. '/' then
        on_dir(hypr_config_dir)
        return
      end

      local root = vim.fs.root(bufnr, lua_root_markers)
      if root then
        on_dir(root)
      end
    end,
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          globals = { 'hl' },
        },
        workspace = {
          library = lua_workspace_library,
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu.
require('mason').setup()

-- Only used to translate lspconfig server names to mason package names (e.g. lua_ls -> lua-language-server).
-- Servers are enabled explicitly below.
require('mason-lspconfig').setup { automatic_enable = false }

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, {
  'stylua', -- Used to format Lua code
  'tree-sitter-cli', -- Used by nvim-treesitter to build parsers
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for server_name, server in pairs(servers) do
  vim.lsp.config(server_name, server)
end
vim.lsp.enable(vim.tbl_keys(servers))
