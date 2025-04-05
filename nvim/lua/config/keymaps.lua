local k = vim.keymap

-- k.set("n", "<leader>f", ":Files!<cr>")
-- k.set("n", "<leader>g", ":RG!<cr>")


-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
k.set('n', '<Esc>', '<cmd>nohlsearch<CR>')