local k = vim.keymap

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
k.set('n', '<Esc>', '<cmd>nohlsearch<CR>')