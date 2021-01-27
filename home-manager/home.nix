{ config, pkgs, lib, ... }:
let
  unstable = import ../unstable.nix { config.allowUnfree = true; };
in
{
  imports = [
    ./local.nix
  ];

  nixpkgs.config.allowUnfree = true;


  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    alacritty = import ./alacritty.nix { inherit pkgs; };

    git = import ./git.nix;

    ssh = import ./ssh.nix;

    fish = import ./fish.nix { inherit pkgs; };


  };

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
    packages = with pkgs; [
      nixpkgs-fmt
      fortune
      htop
      neofetch
      dnsutils
      whois
      zip
      unzip
      jq
      unrar
      lnav
      speedtest-cli
      python39
    ];
  };
}
