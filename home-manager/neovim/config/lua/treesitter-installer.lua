-- Treesitter configuration - Advanced syntax highlighting and code understanding
-- Provides incremental parsing for better syntax highlighting, indentation, and navigation
--
-- Features:
--   - Context-aware syntax highlighting (better than regex-based)
--   - Smart code selection and navigation
--   - Folding based on syntax tree
--   - Indentation based on syntax
--   - Incremental parsing for performance
--
-- Usage:
--   :TSInstall <language>     - Install parser for specific language
--   :TSUpdate                 - Update all installed parsers
--   :TSBufToggle highlight    - Toggle highlighting
--   :TSPlaygroundToggle       - Open syntax tree viewer (if available)
--
-- Configured languages:
--   c, make, bash, html, javascript, typescript, tsx,
--   git_config, gitcommit, gitignore, json, yaml,
--   python, php
--
-- Features enabled:
--   - Auto-install parsers when opening new file types
--   - Syntax highlighting with treesitter
--   - Disabled for files larger than 100KB (performance)
--
-- Defines a read-write directory for treesitters in nvim's cache dir
local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
vim.fn.mkdir(parser_install_dir, "p")
-- Prevents reinstall of treesitter plugins every boot
vim.opt.runtimepath:append(parser_install_dir)

require'nvim-treesitter.configs'.setup {


  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "make", "bash", "html", "css", "javascript", "typescript", "tsx", "git_config", "gitcommit", "gitignore", "csv", "json", "yaml", "python", "php", "dockerfile", "markdown" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  parser_install_dir = parser_install_dir,

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
