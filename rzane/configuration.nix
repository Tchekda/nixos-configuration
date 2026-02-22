{ config, pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  home-manager = {
    backupFileExtension = "bak";
    useUserPackages = true;
    users.dtch = {
      imports = [ ../home-manager/rzane/default.nix ];
      # home.username = lib.mkForce "dtch";
    };
  };

  # nix config
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # disabled due to https://github.com/NixOS/nix/issues/7273
      # auto-optimise-store = true;
    };
    enable = false; # using determinate installer
  };

  programs.fish.enable = true;

  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    defaults = {
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
    };
    primaryUser = "dtch";
    stateVersion = 6;
  };
  users = {
    knownUsers = [ "dtch" ];
    users."dtch" = {
      home = "/Users/dtch";
      shell = pkgs.fish;
      uid = 501;
    };
  };
  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };

}
