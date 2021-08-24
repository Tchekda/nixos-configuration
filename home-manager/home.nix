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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 7200;
      maxCacheTtl = 7200;
    };

    picom = {
      enable = true;
      vSync = true;
      shadow = true;
      shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];
      backend = "glx";
      fade = true;
      fadeDelta = 5;
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
      iperf3
      mtr
      python39
      python39Packages.pip
      file
      busybox
    ];
  };
}
