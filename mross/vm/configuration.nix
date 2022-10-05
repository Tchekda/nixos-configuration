{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
      ../../tchekda_user.nix
      ./nginx.nix
      ./seedbox.nix
      ./containers.nix
      (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.all.proxy_ndp" = 1;
    };
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      efi.canTouchEfiVariables = true;
    };
  };

  documentation.enable = false;


  environment.systemPackages = with pkgs; [
    dnsutils
    git
    htop
    iotop
    lnav
    nano
    tcpdump
    wget
  ];


  home-manager.users.tchekda = {
    imports = [ ../../home-manager/mross/default.nix ];
  };

  networking = {
    hostName = "mross-vm";

    firewall = {
      allowedTCPPorts = [ 22 80 443 ];
    };
    useDHCP = false;
    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      ipv4 = {
        addresses = [{ address = "192.168.1.201"; prefixLength = 24; }];
      };
      ipv6 = {
        addresses = [{ address = "2001:bc8:2e2a:201::1"; prefixLength = 64; }];
      };
      # tempAddress = "disabled";
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "2001:bc8:2e2a:1::1";
      interface = "eth0";
    };
    nameservers = [ "62.210.16.6" "2606:4700:4700::1111" "1.1.1.1" ];

  };

  nixpkgs.config.allowUnfree = true;

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
    vscode-server.enable = true;
  };

  system.stateVersion = "21.11";

  time.timeZone = "Europe/Paris";

  users.users = {
    tchekda.extraGroups = [ "docker" ];
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGY/SVAkoinPz2YLLKMb29Qgv2dqSgU/dFnaxHaMPaG/SH6wzw3+mcS11flaU1ZJa3Q46fVEqOfAxu/VzXSx64ZQDKWWf7LQ+D5xSsaYPUSAqLQZ3OwATd6ZK+AOXVDStiB6JiWf0A0gaYWVfeZn7cH13WL8Px6kKmMCXrsHbo84dKuFeTDTafizH2nMC12jnf8vm/lSCc/Q7SNyqu3sXE8iU7/s2inG9s4GH5R3Ait9AoX50JHDQo2268NyjfWp8EQcLpUVRj4ujtqMtKHFzVKQacBTdzjfFJTIDSZhzF2+Dik1ZfmOjCsX2zzpIk5yZ02bBjZAzrVPwh4YwZRwwGsspx0yAdlrWaMEYc2YjY+TmVJfvZU6dz92oR4dNms7iTSHOIMu9eyhsIWR7+fOpm5mMPd6FvTMeNsip9iQPbG4rLQscN+vWNOXt+BY18MFIRJfjVM7XckGtHyjvl8lsGXWA7v5v+Wf7IuPIYERXHuNt5Ryd2SDsYaqlf4XZHy1hw3A4YQrVyiwmPhRKIf1ko9tsmT0/S/0eCr7EorbZnSAHvpDIlJVZ4hyyMe86qroO+rX8U0LXYXovZIYfFSn9CKEuEPGtI+/pJLrlHe5E49j6Jgmog+4Zc35dpOX5QH7rLxPydRMRPCW6+Iu4tsJ6sO2tfZDOeK/j9fTZXxK2C3Q== tchekda@termius"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBLM62vg0tFzObsAm+dojYFqX2yOizoprSIhoMNLJe37QV8XI8BexoYr6W3FgPEtiI5U5U1nCFtt9Pyzmjwcole0AAAAEc3NoOg== contact@tchekda.fr"
      ];
    };
  };

  virtualisation.docker = {
    enable = true;
    extraOptions = "--ipv6 --fixed-cidr-v6 2001:bc8:2e2a:201:1::/80";
  };
}
