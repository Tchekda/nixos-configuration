-- Telescope configuration - Fuzzy finder and picker
-- Highly extendable fuzzy finder over lists
--
-- Common usage:
--   :Telescope find_files       - Find files in project
--   :Telescope live_grep        - Search text in project (requires ripgrep)
--   :Telescope buffers          - List open buffers
--   :Telescope help_tags        - Search help documentation
--   :Telescope git_files        - Find files tracked by git
--   :Telescope lsp_references   - Find LSP references
--   :Telescope diagnostics      - Show LSP diagnostics
--
-- Keybindings in picker:
--   <C-n>/<Down>  - Next item
--   <C-p>/<Up>    - Previous item
--   <C-c>/<Esc>   - Close telescope
--   <CR>          - Confirm selection
--   <C-x>         - Open in horizontal split
--   <C-v>         - Open in vertical split
--   <C-t>         - Open in new tab
--
-- Features:
--   - Uses ripgrep for fast text search
--   - Ignores common build artifacts and version control
--   - Horizontal layout with custom border

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "» ",
    selection_caret = "» ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {"./target", ".git/", ".cache", "%.o", "%.a", "%.out", "%.class", "%.d",
		"%.pdf", "%.mkv", "%.mp4", "%.zip", "compile_commands.json"},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    -- Original
    -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    borderchars = { '─', ' ', '─', ' ', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}

