{ ... }:

{
  imports = [
    ../home.nix
    ../server.nix
  ];

  programs.git.extraConfig.safe.directory = "*";
}
