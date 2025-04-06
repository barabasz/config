-- Globals

local globals = {
  deprecation_warnings = false, -- Disable deprecation warnings
  lazy = true, -- Enable lazy loading of plugins
  mapleader = " ", -- Set the leader key
  maplocalleader = "\\", -- Set the local leader key
  markdown_recommended_style = 0, -- Disable recommended style for markdown
  have_nerd_font = true, -- Set to true if you have a Nerd Font installed
  python3_host_prog = "/opt/homebrew/bin/python3", -- Path to the Python 3 interpreter
  snacks_animate = true, -- Enable animations for snacks.nvim
  trouble_lualine = true, -- Enable lualine integration for trouble.nvim
}

for k, v in pairs(globals) do vim.g[k] = v end

-- Options

local tabsize = 4 -- Number of spaces that a <Tab> in the file counts for.

local options = {
  autoindent = true, -- Copy indent from current line when starting a new line
  breakindent = true, -- Enable break indent
  clipboard = vim.env.SSH_TTY and "" or "unnamedplus", -- uses the clipboard register for all operations except yank
  conceallevel = 2, -- Conceal level for syntax highlighting
  confirm = true, -- Ask for confirmation when closing unsaved buffers
  cursorcolumn = false, -- Highlight the screen column of the cursor with CursorColumn
  cursorline = true, -- Highlight the screen line of the cursor with CursorLine
  encoding = "UTF-8", -- Sets the character encoding used inside Vim.
  expandtab = false, -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>
  grepformat = "%f:%l:%c:%m", -- Format of the output from the grep program
  grepprg = "rg --vimgrep", -- Grep tool for searching
  hidden = true, -- When on a buffer becomes hidden when it is |abandon|ed
  ignorecase = true, -- Case-insensitive searching UNLESS \C or one or more capital letters are used
  inccommand = "split", -- Show substitution results as you type
  listchars = "eol:↵,tab:» ,trail:·,extends:>,precedes:<", -- Characters to use for displaying whitespace
  list = true, -- Show some invisible characters (tabs...)
  pumblend = 10, -- Popup blend
  pumheight = 10, -- Maximum number of entries in a popup
  mouse = "a", -- Enable the use of the mouse. "a" you can use on all modes
  number = true, -- Print the line number in front of each line
  relativenumber = false, -- Show the line number relative to the line with the cursor in front of each line
  ruler = false, -- Disable the default ruler
  scrolloff = 10, -- Minimal number of screen lines to keep above and below the cursor
  shiftwidth = tabsize, -- Number of spaces to use for each step of (auto)indent
  showcmd = true, -- Show (partial) command in the last line of the screen
  showmatch = true, -- When a bracket is inserted, briefly jump to the matching one
  showmode = false, -- Don't show the mode, since it's already in the status line
  showtabline = 2, -- Tabline: 1 - at least two windows, 2 - always, 0 - never
  signcolumn = 'yes', -- Always show the signcolumn, otherwise it would shift the text each time
  smartcase = true, -- Override the 'ignorecase' option if the search pattern contains upper case characters
  smartindent = true, -- Do smart autoindenting when starting a new line
  smoothscroll = true, -- Smooth scrolling
  softtabstop = tabsize, -- Number of spaces that a <Tab> counts for while performing editing operations
  spell = true, -- Enable spell checking
  spelllang = "en,pl", -- Language for spell checking
  splitbelow = true, -- Put new windows below current one
  splitkeep = "screen", -- When splitting a window, keep the current screen position
  splitright = true, -- Put new windows right of current one
  syntax = "on", -- When this option is set, the syntax with this name is loaded
  tabstop = tabsize, -- Number of spaces that a <Tab> in the file counts for
  termguicolors = true, -- Use 24-bit (true-color) mode
  title = true, -- When on, the title of the window will be set to the value of 'titlestring'
  ttimeoutlen = 0, -- The time in milliseconds that is waited for a key code or mapped key sequence to complete
  undofile = true, -- Save undo history
  undolevels = 10000, -- The maximum number of changes that can be undone
  updatetime = 200, -- Faster completion (4000ms default)
  wildmenu = true, -- Command-line completion operates in an enhanced mode
  wrap = false, -- Don't wrap long lines
}

for k, v in pairs(options) do vim.o[k] = v end
