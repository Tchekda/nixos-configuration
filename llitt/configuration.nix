{ config, pkgs, ... }:

{
  imports =
    [
      ../tchekda_user.nix
      <home-manager/nixos>
      ./containers.nix
      ./nginx.nix
      ./dn42
    ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_rpi4;
    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };
      grub = {
        enable = false;
      };
      generic-extlinux-compatible.enable = true;
    };
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "xhci_pci" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      # Some gui programs need this
      "cma=128M"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "llitt";

    firewall.enable = false;

    nameservers = [ "127.0.0.1" "1.1.1.1" "2606:4700:4700::1111" ];

    defaultGateway6 = { address = "fe80::8e97:eaff:fe33:30b6"; interface = "eth0"; };

    interfaces.eth0 = {
      ipv6.addresses = [{ address = "2a01:e0a:2b1:f401::1"; prefixLength = 64; }];
    };
  };

  documentation.enable = false;

  users.users = {
    tchekda.extraGroups = [ "docker" ];
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
      ];
    };
  };

  home-manager.users.tchekda = {
    imports = [ ../home-manager/llitt/default.nix ];
  };

  environment.systemPackages = with pkgs; [
    git
    htop
    libraspberrypi
    nano
    tcpdump
    wget
  ];

  virtualisation.docker.enable = true;

  services = {
    openssh.enable = true;
    mosquitto = {
      enable = true;
      listeners = [{
        address = "0.0.0.0";
        users.tchekda = {
          acl = [ "readwrite #" ];
          hashedPassword = "$6$t/OetPjG29PEKvLc$Vx3CGiLe23IKAWnVGPqFpAbEeIMahC6+wyICKDqPQh1bP0Cu6cHikmmXQMx2uvbZ0E0Bebw/aTnH71R40GJv8A==";
        };
      }];
    };
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
