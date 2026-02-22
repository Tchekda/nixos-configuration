{ lib, ... }:

{
  imports = [
    ../home.nix
    ./git.nix
  ];
  programs = {
    command-not-found.enable = lib.mkForce false;
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    fish = {
      shellAbbrs = {
        nrs = "sudo darwin-rebuild --flake /Users/dtch/nixos-configuration#rzane switch";
      };
    };
    ssh = {
      enable = true;
      includes = [
        "/Users/dtch/.colima/ssh_config"
      ];
      matchBlocks = {
        "*" = {
          identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
        };
      };
    };
  };
}
