{ pkgs, ... }:

{
  imports = [ ../home.nix ];

  home.packages = with pkgs; [
    speedtest-cli
  ];
}
