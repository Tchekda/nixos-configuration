{ config, pkgs, lib, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/29b658e67e0284b296e7b377d47960b5c2c4db08)
    { config = config.nixpkgs.config; };
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

    git = {
      enable = true;
      userName = "David Tchekachev";
      userEmail = "contact" + "@" + "tchekda.fr";
      signing = {
        key = "A4EADA0F";
        signByDefault = true;
      };
    };

    ssh = {
      enable = true;
      extraOptionOverrides = { "AddKeysToAgent" = "yes"; };
    };

    fish = import ./fish.nix { inherit pkgs; };

  };

  services = {
    gpg-agent = {
      enable = false;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    polybar = import ./polybar.nix { inherit pkgs; };

    dunst = import ./dunst.nix { inherit pkgs; };

    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -c 1e272e";

    };

  };

  home = {
    username = "tchekda";
    homeDirectory = "/home/tchekda";
    packages = with pkgs; [
      feh
      brightnessctl
      flameshot
      fortune
      htop
      neofetch
      zip
      unzip
      alacritty
      unrar
      gparted
      lnav
      pavucontrol
      firefox
      docker-compose
      vscode
      unstable.jetbrains.jdk
      unstable.jetbrains-mono
      unstable.jetbrains.phpstorm
      unstable.jetbrains.rider
      unstable.jetbrains.pycharm-professional
      discord
      teams
      bitwarden
    ];
  };


  xsession.windowManager.i3 = import ./i3.nix { inherit pkgs lib; };
}
