-- lualine.nvim
-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
-- To check current config use :lua print(vim.inspect(require('lualine').get_config()))
return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "stevearc/aerial.nvim"
    },
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'tokyonight',
                component_separators = {
                    left = '',
                    right = ''
                },
                section_separators = {
                    left = '',
                    right = ''
                },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {}
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100
                }
            },
            sections = {
                lualine_a = {
                    'mode'
                },
                lualine_b = {
                    'branch',
                    'diff',
                    'diagnostics'
                },
                lualine_c = {
                    {'filename',
                        path = 3,
                        symbols = {
                            modified = '[+]',
                            readonly = '[-]',
                            unnamed = '[?]',
                            newfile = '[*]'}}
                },
                lualine_x = {},
                lualine_y = { {'encoding', show_bomb = true}, 'fileformat' },
                lualine_z = { {'filetype', colored = true, icon_only = false} }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            -- tabline --> tabline.lua
            tabline = {},
            winbar = {
                lualine_a = { "location" },
                lualine_b = { "progress" },
                lualine_c = { "aerial"},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { {"datetime", style = '%H:%M:%S'} }
            },
            inactive_winbar = {},
            extensions = {'aerial', 'quickfix', 'fugitive', 'fzf'}
        }
    end
}
