# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
# aarch64 --argstr system aarch64-linux 

{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    ../tchekda_user.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "swheeler";

    firewall.allowedTCPPorts = [ 22 2217 ];

    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      ipv4 = {
        addresses = [{ address = "192.168.0.17"; prefixLength = 24; }];
      };
      ipv6 = {
        addresses = [{ address = "2a01:e0a:7a:640::1711"; prefixLength = 64; }];
      };
      tempAddress = "disabled";
    };
    defaultGateway = {
      address = "192.168.0.254";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "fe80::de00:b0ff:fe3a:249e";
      interface = "eth0";
    };

    nameservers = [ "2606:4700:4700::1111 1.1.1.1 192.168.0.254" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    nano
    git
    htop
  ];

  home-manager.users.tchekda = {
    imports = [ ../home-manager/swheeler/default.nix ];
  };

  users.users = {
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
      ];
    };
  };

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "21.11";
}