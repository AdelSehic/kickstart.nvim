local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

vim.pack.add {
  -- 'https://github.com/catppuccin/nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/windwp/nvim-autopairs',
  -- Add indentation guides even on blank lines
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  -- Detect tabstop and shiftwidth automatically
  'https://github.com/tpope/vim-sleuth',
  -- Highlight todo, notes, etc in comments
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/folke/todo-comments.nvim',
  -- Maintained fork of the original (now deleted) hadronized/hop.nvim
  'https://github.com/smoka7/hop.nvim',
  { src = 'https://github.com/akinsho/toggleterm.nvim', version = vim.version.range '*' },
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',
}

-- vim.cmd.colorscheme 'catppuccin-macchiato'
-- vim.cmd.hi 'Comment gui=none'
vim.cmd.colorscheme 'dayfox'

-- Completion brackets are handled by blink.cmp (`completion.accept.auto_brackets`)
require('nvim-autopairs').setup {
  check_ts = true,
}

-- See `:help ibl`
require('ibl').setup {}

require('todo-comments').setup { signs = false }

require('hop').setup {
  keys = 'etovxqpdygfblzhckisuran',
}

require('toggleterm').setup {
  open_mapping = [[<c-\>]],
  autochdir = true,
  direction = 'float',
  float_opts = {
    border = 'curved',
    winblend = 0,
  },
}

-- vim.keymap.set('n', 'zR', require('ufo').openAllFold)
-- vim.keymap.set('n', 'zM', require('ufo').closeAllFold)

-- tresitter folds, I prefer LSP folds
-- require("ufo").setup({
--   provider_selector = function (bufnr, filetype, buftype)
--     return {'treesitter', 'indent'}
--   end
-- })
require('ufo').setup {
  fold_virt_text_handler = handler,
}
