{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline ];
    settings = { ignorecase = true; };
    extraConfig = ''
      syntax on
      set expandtab
      set shiftwidth=4
      set tabstop=4
      set softtabstop=4
    '';
  };
}
