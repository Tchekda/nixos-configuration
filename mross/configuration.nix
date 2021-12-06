{ config, pkgs, ... }:

{
  imports =
    [
      # ./hardware-configuration.nix
      ../tchekda_user.nix
      <home-manager/nixos>
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        version = 2;
        splashImage = null;
        device = "/dev/sda";
      };
    };
  };

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "mross";
  };

  users.users = {
    tchekda.extraGroups = [ "docker" ];
    root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
    ];
  };

  home-manager.users.tchekda = {
    imports = [ ../home-manager/mross/default.nix ];
  };

  environment.systemPackages = with pkgs; [
    wget
    nano
    git
    htop
    lnav
    dnsutils
  ];

  virtualisation.docker.enable = true;

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  system.stateVersion = "21.11";
}
