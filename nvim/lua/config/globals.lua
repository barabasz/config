-- Global options
-----------------

local globals = {
  mapleader = " ", -- Set the leader key
  maplocalleader = "\\", -- Set the local leader key
  have_nerd_font = true, -- Set to true if you have a Nerd Font installed
  python3_host_prog = "/opt/homebrew/bin/python3", -- Path to the Python 3 interpreter
}

for k, v in pairs(globals) do vim.g[k] = v end
