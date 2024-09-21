-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
        { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
        filesystem = {
            window = {
                mappings = {
                    ['\\'] = 'close_window',
                    ['e'] = function() vim.api.nvim_exec2("Neotree focus filesystem left", { output = true }) end,
                    ['b'] = function() vim.api.nvim_exec2("Neotree focus buffers left", { output = true }) end,
                    ['g'] = function() vim.api.nvim_exec2("Neotree focus git_status left", { output = true }) end,
                    ['o'] = "system_open",
                },
            },
        },
        commands = {
            system_open = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.fn.jobstart({ "xdg-open", path }, { detach = true })
            end,
        },
    },
}
