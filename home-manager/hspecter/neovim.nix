{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua << EOF
        local packer = require('packer')
        require('packer').startup(function()
          use 'wbthomason/packer.nvim' -- Package manager
          use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
        end)
      EOF
    '';
    extraPackages = with pkgs; [
      tree-sitter
      clang
    ];
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      vim-nix
      nvim-treesitter
      nvim-lspconfig
    ];
  };
}
