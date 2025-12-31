{ ... }:

{
  imports = [
    ../home.nix
    ../server.nix
  ];
  programs = {
    fish = {
      shellAbbrs = {
        nrs = "sudo nixos-rebuild -I \"nixos-config=/home/tchekda/nixos-configuration/mross/configuration.nix\" switch";
      };
    };
  };
}
