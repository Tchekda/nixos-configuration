{ config, pkgs, lib, ... }:
let
  unstable = import ../unstable.nix { config.allowUnfree = true; };
  init-shell-command = pkgs.callPackage ./init-shell-command.nix { };
  my_lnav = if pkgs.system == "x86_64-linux" then [ pkgs.lnav ] else [ ];
in
{
  imports = [
    ./git.nix
  ];

  nixpkgs.config.allowUnfree = true;

  news.display = "silent";

  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    htop.enable = true;

    ssh = {
      enable = true;
      extraOptionOverrides = { "AddKeysToAgent" = "yes"; };
      forwardAgent = true;
      serverAliveInterval = 60;
    };

    fish = import ./fish.nix { inherit pkgs; };

    direnv = {
      enable = true;
    };

  };

  systemd.user.startServices = true;

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 7200;
      maxCacheTtl = 7200;
    };
  };


  home = {
    username = "tchekda";
    homeDirectory = "/home/tchekda";
    sessionPath = [
      "/home/tchekda/.local/bin"
    ];
    packages = with pkgs; [
      nixpkgs-fmt
      neofetch
      dnsutils
      whois
      zip
      unzip
      jq
      unrar
      iperf3
      mtr
      python39
      python39Packages.pip
      file
      busybox
      init-shell-command
    ] ++ my_lnav;
    stateVersion = "21.05";
  };
}
