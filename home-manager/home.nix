{ config, pkgs, lib, ... }:
let
  init-shell-command = pkgs.callPackage ./init-shell-command.nix { };
  my_lnav = if pkgs.system == "x86_64-linux" then [ pkgs.lnav ] else [ ];
in
{
  imports = [
    ./fish.nix
    ./git.nix
  ];



  home = {
    username = "tchekda";
    homeDirectory = "/home/tchekda";
    sessionPath = [
      "/home/tchekda/.local/bin"
    ];
    packages = with pkgs; [
      bat
      dnsutils
      file
      init-shell-command
      inetutils
      iperf3
      jq
      mtr
      neofetch
      python311
      python311Packages.pip
      unrar
      unzip
      zip
    ] ++ my_lnav;
    stateVersion = "21.05";
  };

  nixpkgs = {
    config.allowUnfree = true;
    # overlays = [
    #   (self: super: {
    #     sphinx = drv: drv.overridePythonAttrs (old: { doCheck = false; });
    #   })
    # ];
  };

  news.display = "silent";

  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    man.enable = false;

    htop.enable = true;

    ssh = {
      enable = true;
      extraOptionOverrides = { "AddKeysToAgent" = "yes"; };
      forwardAgent = true;
      serverAliveInterval = 60;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };

  systemd.user.startServices = true;

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 7200;
      enableSshSupport = true;
      enableExtraSocket = true;
      maxCacheTtl = 7200;
      pinentryPackage = pkgs.pinentry-tty;
    };
  };

}
