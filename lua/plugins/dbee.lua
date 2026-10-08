-- The dbee binary is installed/updated by the `PackChanged` build hook in `init.lua`.
--  If it fails, try calling `require('dbee').install()` with one of these parameters:
--    "curl", "wget", "bitsadmin", "go"
vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/kndndrj/nvim-dbee',
}

require('dbee').setup(--[[optional config]])
