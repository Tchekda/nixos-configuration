{ ... }:

{
  imports = [ ../home.nix ];

  programs = {
    fish = {
      shellAbbrs =
        {
          nrs = "sudo nixos-rebuild -I \"nixos-config=/home/tchekda/nixos-configuration/llitt/configuration.nix\" switch";
          hms = "home-manager -f /home/tchekda/nixos-configuration/home-manager/llitt/default.nix switch -b backup";
        };
    };
  };
}
