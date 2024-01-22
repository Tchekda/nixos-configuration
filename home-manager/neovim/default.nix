{ pkgs, lib, ... }:
let
  nixos-23_05 = import <nixos-23.05> { };
in
{
  programs.neovim = {
    enable = true;
    # extraConfig = builtins.readFile ./init.vim + builtins.readFile ./keymap.vim;
    # extraLuaConfig = builtins.concatStringsSep "\n" (map (file: builtins.readFile file) (lib.filesystem.listFilesRecursive ./lua));
    extraPackages = with pkgs;
      [
        clang
        ripgrep
        tree-sitter
      ];
    plugins = with pkgs.vimPlugins; [
      # packer-nvim
      vim-nix
      luasnip
      aurora
      cmp-nvim-lsp
      lspsaga-nvim
      mason-nvim
      mason-lspconfig-nvim
      nvim-cmp
      nvim-colorizer-lua
      nvim-compe
      nvim-lspconfig
      nixos-23_05.vimPlugins.nvim-treesitter.withAllGrammars
      nvim-web-devicons
      onedark-nvim
      plenary-nvim
      telescope-nvim
      todo-comments-nvim
      toggleterm-nvim
      vim-eunuch
      vim-fugitive
      vim-hybrid-material
      vim-snippets
    ];
    viAlias = true;
    vimAlias = true;
  };
  xdg.configFile."nvim" = { source = ./config; recursive = true; };
}
