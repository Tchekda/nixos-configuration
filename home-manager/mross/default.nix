{ ... }:

{
  imports = [
    ../home.nix
    ../server.nix
  ];
  programs = {
    fish = {
      shellAbbrs = {
        nrs = "sudo nixos-rebuild switch --flake /home/tchekda/nixos-configuration#mross";
      };
    };
  };
}
