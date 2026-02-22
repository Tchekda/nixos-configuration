{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # extraConfig = builtins.readFile ./init.vim + builtins.readFile ./keymap.vim;
    # extraLuaConfig = builtins.concatStringsSep "\n" (map (file: builtins.readFile file) (lib.filesystem.listFilesRecursive ./lua));
    extraPackages = with pkgs; [
      ripgrep
      tree-sitter
    ] ++ lib.optionals stdenv.isLinux [
      xclip # x11
      wl-clipboard # wayland
    ];
    plugins = with pkgs.vimPlugins; [
      # Plugin manager (not actively used on NixOS since plugins are managed via Nix)
      packer-nvim

      # Git integration - provides :Git commands for git operations within Vim
      # Usage: :Git status, :Git commit, :Git push, etc.
      vim-fugitive

      # Lua utility library required by many plugins (especially telescope)
      plenary-nvim

      # Fuzzy finder for files, grep, buffers, and more
      # Usage: <leader>ff for files, <leader>fg for live grep, <leader>fb for buffers
      telescope-nvim

      # Better syntax highlighting using tree-sitter parsers
      # Automatically provides context-aware highlighting for all grammars
      nvim-treesitter.withAllGrammars

      # Highlights color codes (e.g., #ffffff, rgb(255,0,0)) with their actual colors
      # Usage: :ColorizerToggle
      nvim-colorizer-lua

      # File type icons for file explorers and other plugins
      nvim-web-devicons

      # LSP (Language Server Protocol) configuration
      # Provides IDE-like features: autocomplete, go-to-definition, diagnostics
      # Usage: gd (go to definition), K (hover docs), <leader>ca (code actions)
      nvim-lspconfig

      # LSP completion source for nvim-cmp
      cmp-nvim-lsp

      # LSP installer - manage language servers
      # Usage: :Mason to open installer UI
      mason-nvim

      # Bridge between mason and lspconfig
      mason-lspconfig-nvim

      # Autocompletion engine
      # Shows completion popup as you type
      # Usage: <Tab> to navigate, <CR> to confirm, <C-Space> to trigger
      nvim-cmp

      # Snippet engine for code snippets
      # Usage: <Tab> to expand and jump through snippet placeholders
      luasnip

      # Collection of snippets for various languages
      vim-snippets

      # Enhanced LSP UI with better code actions, rename, finder
      # Usage: <leader>ca (code action), <leader>rn (rename), gh (lsp finder)
      lspsaga-nvim

      # OneDark color scheme
      # Usage: :colorscheme onedark
      onedark-nvim

      # Terminal manager - open terminals in floating windows or splits
      # Usage: <C-\> to toggle terminal, <C-t> for horizontal split
      toggleterm-nvim

      # Highlight and search for TODO, FIXME, NOTE comments
      # Usage: :TodoTelescope to search all todos
      todo-comments-nvim

      # Unix file operations - :Remove, :Move, :Rename, :Mkdir, etc.
      # Usage: :Remove to delete file, :Rename to rename file
      vim-eunuch

      # Nix syntax highlighting and filetype detection
      vim-nix

      # Hybrid Material color scheme
      # Usage: :colorscheme hybrid_material
      vim-hybrid-material
    ];
    viAlias = true;
    vimAlias = true;
  };
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
