{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    # extraConfig = builtins.readFile ./init.vim + builtins.readFile ./keymap.vim;
    # extraLuaConfig = builtins.concatStringsSep "\n" (map (file: builtins.readFile file) (lib.filesystem.listFilesRecursive ./lua));
    extraPackages = with pkgs; [
      clang
      ripgrep
      tree-sitter
      xclip # x11
      wl-clipboard # wayland
    ];
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      vim-fugitive
      plenary-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      nvim-colorizer-lua
      nvim-web-devicons
      nvim-lspconfig
      cmp-nvim-lsp
      mason-nvim
      mason-lspconfig-nvim
      nvim-cmp
      luasnip
      vim-snippets
      lspsaga-nvim
      onedark-nvim
      aurora
      toggleterm-nvim
      todo-comments-nvim
      vim-eunuch

      vim-nix
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
