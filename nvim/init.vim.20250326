syntax on
set nocompatible
filetype plugin on
set number
set tabstop=4
set shiftwidth=4
set noexpandtab
set listchars=eol:⏎,tab:⎯⎯›,trail:␠,nbsp:⎵
set laststatus=2 " always show status line
set scrolloff=3  " always show 3 rows from edge of the screen

set list
highlight NonText ctermfg=238

"" PLUGINS
call plug#begin()
" Basic blugins
Plug 'tpope/vim-sensible'
Plug 'ntpeters/vim-better-whitespace'
Plug 'paretje/nvim-man'

" NCM2 (nvim-completion-manager)
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
" completion sources

Plug 'ncm2/ncm2-bufword'         " Words from current buffer
Plug 'ncm2/ncm2-path'            " Files/Path
Plug 'ncm2/ncm2-cssomni'         " CSS
Plug 'ncm2/ncm2-tern'            " JavaScript
Plug 'phpactor/ncm2-phpactor'    " PHP
Plug 'ncm2/ncm2-jedi'            " Python
Plug 'ncm2/ncm2-pyclang'         " C/C++
Plug 'subnut/ncm2-github-emoji'  " GitHub emoji source for NCM2
Plug 'oncomouse/ncm2-biblatex'   " Markdown

" other plugins
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'kevinhwang91/rnvimr'

call plug#end()
"" PLUGINS END

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect



lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'powerline_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
END

