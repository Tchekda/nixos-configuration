-- Lspsaga configuration - Enhanced LSP UI
-- Provides a better user interface for LSP actions
--
-- Features:
--   - Better code action UI
--   - Floating window for hover docs
--   - Improved rename UI with preview
--   - LSP finder for definitions/references
--   - Diagnostic navigation with better visuals
--
-- Key features configured:
--   - Custom diagnostic signs and icons
--   - Code action preview and execution
--   - Definition and reference finder
--   - Rename with preview
--   - Single border style for windows

require('lspsaga').setup {
    debug = true,
    use_saga_diagnostic_sign = true,
    -- diagnostic sign
    error_sign = "",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    diagnostic_header_icon = "   ",

    -- code action title icon
    code_action_icon = " ",
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
    },
    code_action_keys = {
        quit = "q",
        exec = "<CR>",
    },

    finder_definition_icon = "  ",
    finder_reference_icon = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
        open = "o",
        vsplit = "s",
        split = "i",
        quit = "q",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
    },

    rename_prompt_prefix = "➤",
    rename_output_qflist = {
        enable = false,
        auto_open_qflist = false,
    },
    rename_action_keys = {
        quit = "<C-c>",
        exec = "<CR>",
    },

    border_style = "single",
    definition_preview_icon = "  ",
    server_filetype_map = {},
    diagnostic_prefix_format = "%d. ",
    diagnostic_message_format = "%m %c",
    highlight_prefix = false,
}

