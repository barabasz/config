-- aerial.nvim
-- A code outline window for skimming and quick navigation
return {
    "stevearc/aerial.nvim",
    opts = {
        autojump = true, -- jump to symbol when the cursor moves
        close_on_select = false,
        default_direction = "prefer_right", -- new aerial window on the right or left
        resize_to_content = true,
        show_guides = true,
        show_guide_tree = true
    }
}

