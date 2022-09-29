{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../tchekda_user.nix
      ./nginx.nix
      <home-manager/nixos>
      ./containers.nix
      ./fider/fider.nix
      ./webhook.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        splashImage = null;
        version = 2;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    git
    htop
    lnav
    nano
    wget
  ];

  home-manager.users.tchekda = {
    imports = [ ../home-manager/kbennett/default.nix ];
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };


  networking = {
    dhcpcd = {
      extraConfig = ''
        interface ens18
        static ip6_address=2a01:cb05:8fdb:2555:e490:e2ff:fe7b:497e/64
      '';
      persistent = true;
    };

    firewall = {
      allowedTCPPorts = [ 22 443 ];
    };

    hostName = "kbennett";

    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

    useDHCP = true;
  };

  documentation.enable = false;

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  system.stateVersion = "21.05"; # Did you read the comment?

  time.timeZone = "Europe/Paris";


  users.users = {
    tchekda.extraGroups = [ "docker" ];
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
      ];
    };
  };

  virtualisation.docker = {
    enable = true;
  };
}
