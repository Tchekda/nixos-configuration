{ config, pkgs, lib, ... }:
let
  unstable = import ../unstable.nix { config.allowUnfree = true; };
  init-shell-command = pkgs.callPackage ./init-shell-command.nix { };
in
{

  nixpkgs.config.allowUnfree = true;

  news.display = "silent";

  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    htop.enable = true;

    git = import ./git.nix;

    ssh = import ./ssh.nix;

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
    sessionVariables = {
      PATH = "/home/tchekda/.local/bin:\${PATH}";
    };
    packages = with pkgs; [
      nixpkgs-fmt
      neofetch
      dnsutils
      whois
      zip
      unzip
      jq
      unrar
      lnav
      iperf3
      mtr
      python39
      python39Packages.pip
      file
      busybox
      init-shell-command
    ];
    stateVersion = "21.05";
  };
}
