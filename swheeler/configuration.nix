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
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
    };
  };

  documentation.enable = false;

  environment.systemPackages = with pkgs; [
    git
    htop
    nano
    wget
  ];

  home-manager.users.tchekda = {
    imports = [ ../home-manager/swheeler/default.nix ];
  };

  networking = {

    defaultGateway = {
      address = "192.168.0.254";
      interface = "eth0";
    };
    # defaultGateway6 = {
    #   address = "fe80::de00:b0ff:fe3a:249e";
    #   interface = "eth0";
    # };

    firewall = {
      allowedTCPPorts = [ 53 2217 ];
      allowedUDPPorts = [ 53 ];
    };

    hostName = "swheeler";

    interfaces.eth0 = {
      ipv4 = {
        addresses = [{ address = "192.168.0.17"; prefixLength = 24; }];
      };
      ipv6 = {
        addresses = [{ address = "2a01:e0a:7a:640::1711"; prefixLength = 64; }];
      };
      tempAddress = "disabled";
    };

    nameservers = [ "2606:4700:4700::1111" "1.1.1.1" "192.168.0.254" ];

    usePredictableInterfaceNames = false;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    openssh = {
      enable = true;
      ports = [ 2217 ];
    };

    qemuGuest.enable = true;
  };

  system.stateVersion = "21.11";

  time.timeZone = "Europe/Paris";

  users.users = {
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGY/SVAkoinPz2YLLKMb29Qgv2dqSgU/dFnaxHaMPaG/SH6wzw3+mcS11flaU1ZJa3Q46fVEqOfAxu/VzXSx64ZQDKWWf7LQ+D5xSsaYPUSAqLQZ3OwATd6ZK+AOXVDStiB6JiWf0A0gaYWVfeZn7cH13WL8Px6kKmMCXrsHbo84dKuFeTDTafizH2nMC12jnf8vm/lSCc/Q7SNyqu3sXE8iU7/s2inG9s4GH5R3Ait9AoX50JHDQo2268NyjfWp8EQcLpUVRj4ujtqMtKHFzVKQacBTdzjfFJTIDSZhzF2+Dik1ZfmOjCsX2zzpIk5yZ02bBjZAzrVPwh4YwZRwwGsspx0yAdlrWaMEYc2YjY+TmVJfvZU6dz92oR4dNms7iTSHOIMu9eyhsIWR7+fOpm5mMPd6FvTMeNsip9iQPbG4rLQscN+vWNOXt+BY18MFIRJfjVM7XckGtHyjvl8lsGXWA7v5v+Wf7IuPIYERXHuNt5Ryd2SDsYaqlf4XZHy1hw3A4YQrVyiwmPhRKIf1ko9tsmT0/S/0eCr7EorbZnSAHvpDIlJVZ4hyyMe86qroO+rX8U0LXYXovZIYfFSn9CKEuEPGtI+/pJLrlHe5E49j6Jgmog+4Zc35dpOX5QH7rLxPydRMRPCW6+Iu4tsJ6sO2tfZDOeK/j9fTZXxK2C3Q== tchekda@termius"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBLM62vg0tFzObsAm+dojYFqX2yOizoprSIhoMNLJe37QV8XI8BexoYr6W3FgPEtiI5U5U1nCFtt9Pyzmjwcole0AAAAEc3NoOg== contact@tchekda.fr"
      ];
    };
  };
}
