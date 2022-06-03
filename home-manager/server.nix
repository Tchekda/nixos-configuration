{ pkgs, ... }:
{
  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  home.packages = with pkgs; [
    speedtest-cli
  ];


  services.vscode-server.enable = true;
}
