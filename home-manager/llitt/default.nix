{ ... }:

{
  imports = [ ../home.nix ];

  programs = {
    fish = {
      shellAbbrs =
        {
          nrs = "sudo nixos-rebuild --flake /home/tchekda/nixos-configuration#llitt switch";
        };
    };
  };
}
