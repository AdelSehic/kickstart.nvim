-- [[ Treesitter ]]
--  Highlight, edit, and navigate code. See `:help nvim-treesitter`
--
--  This is the `main` branch of nvim-treesitter, the rewrite for Nvim 0.12. It only installs
--  parsers and queries; highlighting and indentation are turned on per buffer below.
--  Building parsers needs the `tree-sitter` CLI, which mason installs (see `plugins/lsp.lua`).
--
--  Nvim 0.12 has built-in incremental selection: in visual mode `an` / `in` grow / shrink
--  the selection to the surrounding / inner node. See `:help v_an`
vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

local ts = require 'nvim-treesitter'

local ensure_installed = { 'go', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'javascript' }

local function has_cli()
  return vim.fn.executable 'tree-sitter' == 1
end

if has_cli() then
  ts.install(ensure_installed)
else
  -- Fresh install: mason is still installing the `tree-sitter` CLI, build the parsers once it's done
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsUpdateCompleted',
    once = true,
    callback = function()
      ts.install(ensure_installed)
    end,
  })
end

-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--  If you are experiencing weird indenting issues, add the language to
--  `additional_vim_regex_highlighting` and `indent_disable`.
local additional_vim_regex_highlighting = { ruby = true }
local indent_disable = { ruby = true }

local function attach(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
    return
  end

  vim.treesitter.start(buf, lang)
  if additional_vim_regex_highlighting[lang] then
    vim.bo[buf].syntax = 'ON'
  end

  if not indent_disable[lang] and vim.treesitter.query.get(lang, 'indents') then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local available = ts.get_available()

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then
      return
    end

    -- Autoinstall languages that are not installed
    if has_cli() and vim.list_contains(available, lang) and not vim.list_contains(ts.get_installed 'parsers', lang) then
      ts.install(lang):await(function()
        attach(args.buf, lang)
      end)
    else
      attach(args.buf, lang)
    end
  end,
})
