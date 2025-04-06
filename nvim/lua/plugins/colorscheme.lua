-- Tokyo Night
-- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme.
return {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {},
    config = function()
        vim.cmd("colorscheme tokyonight-night") -- nigh, storm, day, moon
    end,
}
 