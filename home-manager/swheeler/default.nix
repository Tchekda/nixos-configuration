{ pkgs, ... }:

{
  imports = [ ../home.nix ../server.nix ./appart.nix ];

  home.packages = with pkgs; [
    python39
    python39Packages.virtualenv
  ];
}
