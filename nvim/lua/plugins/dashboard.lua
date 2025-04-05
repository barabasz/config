local version = vim.version()
local verinfo = "Neovim " .. version.major .. "." .. version.minor .. "." .. version.patch
return {
    "folke/snacks.nvim",
    priority = 1000,
    opts = {
        dashboard = {
            width = 50,
            preset = {
                header = verinfo,
                keys = {
                    { icon = " ", key = "f", desc = "Find File", 
                        action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", 
                        action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", 
                        action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", 
                        action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", 
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = "♥ ", key = "h", desc = "Health check", 
                    action = ":checkhealth" },
                    { icon = " ", key = "s", desc = "Restore Session", 
                        section = "session" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", 
                        action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = "※", key = "m", desc = "Mason", 
                        action = ":Mason" },
                    { icon = " ", key = "q", desc = "Quit", 
                        action = ":qa" },
                  },
            },
            sections = {
                { section = "header" },
                { section = "keys", icon = " ", title = "Commands", gap = 0, padding = 1, indent = 3 },
                { section = "recent_files", icon = " ", title = "Recent Files", indent = 3, padding = 1 },
                { section = "startup" },
            },
        },
        toggle = {}
    }
}



