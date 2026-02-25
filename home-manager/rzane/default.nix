{ lib, ... }:

{
  imports = [
    ../home.nix
    ./git.nix
  ];

  home = {
    sessionVariables = {
      TF_CLI_ARGS_plan = "-parallelism=50";
      TF_CLI_ARGS_apply = "-parallelism=50";
    };
  };

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
      shellInit = ''
        mise activate fish --shims | source
      '';
    };

    mise = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
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
