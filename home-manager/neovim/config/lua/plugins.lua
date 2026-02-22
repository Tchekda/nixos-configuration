-- Packer plugin manager configuration
-- NOTE: Most plugins are commented out because they're managed via Nix (see default.nix)
-- Only use this file for plugins not available or not easily configured in Nix

require('packer').startup(function(use)
    -- Plugin manager (self-managing)
    -- use 'wbthomason/packer.nvim'

    -- Git wrapper - provides :Git commands for git operations
    -- use 'tpope/vim-fugitive'

    -- Telescope dependencies and core
    -- use 'nvim-lua/plenary.nvim'  -- Lua utility library
    -- use 'nvim-telescope/telescope.nvim'  -- Fuzzy finder
    -- use 'BurntSushi/ripgrep'  -- Fast search tool used by telescope
    -- use 'nvim-treesitter/nvim-treesitter'  -- Syntax highlighting
    -- use 'MrVyM/tiger-lsp-vim'  -- Tiger language LSP

    -- Color code highlighter (shows colors inline)
    -- use 'norcalli/nvim-colorizer.lua'
    
    -- File type icons for UI elements
    -- use "kyazdani42/nvim-web-devicons"

    -- LSP Configuration and tools
    -- use "neovim/nvim-lspconfig"  -- LSP client configurations
    -- use "hrsh7th/cmp-nvim-lsp"  -- LSP completion source
    -- use "williamboman/mason.nvim"  -- LSP/DAP/Linter installer
    -- use "williamboman/mason-lspconfig.nvim"  -- Mason + lspconfig bridge
    -- use 'hrsh7th/nvim-compe'  -- Old completion plugin (replaced by nvim-cmp)
    
    -- Rust development tools - enhanced LSP features for Rust
    -- Provides inlay hints, cargo integration, and better debugging
    -- Usage: Automatically enhances rust-analyzer LSP
    use 'simrat39/rust-tools.nvim'
    
    -- use 'hrsh7th/nvim-cmp'  -- Completion engine
    -- use({
    --     "L3MON4D3/LuaSnip",  -- Snippet engine
    --     tag = "v2.*", 
    --     run = "make install_jsregexp"  -- Build regex support
    -- })  
    -- use "honza/vim-snippets"  -- Snippet collection
    -- use 'nvimdev/lspsaga.nvim'  -- Enhanced LSP UI

    -- Color schemes
    -- use 'navarasu/onedark.nvim'  -- OneDark theme
    -- use 'ray-x/aurora'  -- Aurora theme
    -- use 'kristijanhusak/vim-hybrid-material'  -- Hybrid Material theme
    
    -- Markdown preview in browser
    -- Usage: :MarkdownPreview to open, :MarkdownPreviewStop to close
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- Terminal manager for integrated terminals
    -- use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    --     require("toggleterm").setup()
    -- end}

    -- Highlight and manage TODO/FIXME/NOTE comments
    -- use 'folke/todo-comments.nvim' 

    -- Unix file operations (:Remove, :Move, :Rename, etc.)
    -- use 'tpope/vim-eunuch' 

end)

