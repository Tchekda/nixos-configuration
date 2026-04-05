{ ... }:

{
  imports = [
    ../home.nix
    ../server.nix
  ];

  programs = {
    fish = {
      shellAbbrs = {
        nrs = "sudo nixos-rebuild switch --flake /home/tchekda/nixos-configuration#kbennett";
      };
    };
    git.settings.safe.directory = "*";
  };
}
