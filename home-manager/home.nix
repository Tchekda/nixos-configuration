{ config, pkgs, lib, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/77d190f10931c1d06d87bf6d772bf65346c71777)
    { config = config.nixpkgs.config; };
in
{
  imports = [
    ./local.nix
    ./battery.nix
  ];

  nixpkgs.config.allowUnfree = true;


  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    alacritty = import ./alacritty.nix { inherit pkgs; };

    git = import ./git.nix;

    ssh = import ./ssh.nix;

    fish = import ./fish.nix { inherit pkgs; };

    autorandr = import ./autorandr.nix { inherit pkgs; };

  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 7200;
      maxCacheTtl = 7200;
      # enableSshSupport = true;
      # enableExtraSocket = true;
    };

    polybar = import ./polybar.nix { inherit pkgs; };

    dunst = import ./dunst.nix { inherit pkgs unstable; };

    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color -c 1e272e --clock";
    };

    blueman-applet.enable = true;

  };

  home = {
    username = "tchekda";
    homeDirectory = "/home/tchekda";
    packages = with pkgs; [
      feh
      brightnessctl
      nixpkgs-fmt
      flameshot
      fortune
      htop
      neofetch
      dnsutils
      zip
      unzip
      jq
      alacritty
      unrar
      gparted
      lnav
      speedtest-cli
      spotify
      pavucontrol
      evince
      firefox-devedition-bin
      vscode
      python39
      dotnet-sdk_3
      unstable.jetbrains.jdk
      unstable.jetbrains-mono
      unstable.jetbrains.phpstorm
      unstable.jetbrains.rider
      unstable.jetbrains.pycharm-professional
      discord
      teams
      zoom-us
      bitwarden
      molotov
      thunderbird
      tdesktop
      pidgin
    ];
  };

  systemd.user.services.caffeine-ng = {
    Unit = {
      Description = "Caffeine-ng, a locker inhibitor";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
    };
  };



  xsession.windowManager.i3 = import ./i3.nix { inherit pkgs lib; };
}
