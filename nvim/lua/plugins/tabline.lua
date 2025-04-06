-- barbar.nvim is a tabline plugin with re-orderable, auto-sizing, clickable tabs,
-- icons, nice highlighting, sort-by commands and a magic jump-to-buffer mode.
-- Plus the tab names are made unique when two filenames match.

return {
    'romgrk/barbar.nvim',
    dependencies = {'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
    },
    opts = {
        tabpages = true,
        animation = true,
    },
    init = function()
        vim.g.barbar_auto_setup = false
    end,
}