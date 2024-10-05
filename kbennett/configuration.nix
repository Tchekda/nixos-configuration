{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../tchekda_user.nix
      ./nginx.nix
      <home-manager/nixos>
      ./containers.nix
      ./immich
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        splashImage = null;
      };
    };
  };

  documentation.enable = false;

  environment.systemPackages = with pkgs; [
    git
    htop
    iotop
    lnav
    nano
    wget
    pkgs.php81
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
        # static ip6_address=2a01:cb05:944a:b8ff:effc:f889:be33:dba3/64
      '';
      persistent = true;
    };

    firewall.allowedTCPPorts = [ 22 ];

    hostName = "kbennett";

    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

    tempAddresses = "disabled";

    useDHCP = true;
  };

  programs.fish.enable = true;


  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  system.stateVersion = "21.05"; # Did you read the comment?

  systemd = {
    # timers."moodle-cron" = {
    #   wantedBy = [ "timers.target" ];
    #   timerConfig = {
    #     OnBootSec = "3m";
    #     OnUnitActiveSec = "3m";
    #     Unit = "moodle-cron.service";
    #   };
    # };

    services."moodle-cron" = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "nginx";
        Restart = "always";
        KillMode = "process";
        ExecStart = ''
          ${pkgs.php81}/bin/php /var/www/moodle/admin/cli/cron.php
        '';
        StandardOutput = "null";
      };
    };
  };


  time.timeZone = "Europe/Paris";


  users.users = {
    tchekda.extraGroups = [ "docker" ];
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGY/SVAkoinPz2YLLKMb29Qgv2dqSgU/dFnaxHaMPaG/SH6wzw3+mcS11flaU1ZJa3Q46fVEqOfAxu/VzXSx64ZQDKWWf7LQ+D5xSsaYPUSAqLQZ3OwATd6ZK+AOXVDStiB6JiWf0A0gaYWVfeZn7cH13WL8Px6kKmMCXrsHbo84dKuFeTDTafizH2nMC12jnf8vm/lSCc/Q7SNyqu3sXE8iU7/s2inG9s4GH5R3Ait9AoX50JHDQo2268NyjfWp8EQcLpUVRj4ujtqMtKHFzVKQacBTdzjfFJTIDSZhzF2+Dik1ZfmOjCsX2zzpIk5yZ02bBjZAzrVPwh4YwZRwwGsspx0yAdlrWaMEYc2YjY+TmVJfvZU6dz92oR4dNms7iTSHOIMu9eyhsIWR7+fOpm5mMPd6FvTMeNsip9iQPbG4rLQscN+vWNOXt+BY18MFIRJfjVM7XckGtHyjvl8lsGXWA7v5v+Wf7IuPIYERXHuNt5Ryd2SDsYaqlf4XZHy1hw3A4YQrVyiwmPhRKIf1ko9tsmT0/S/0eCr7EorbZnSAHvpDIlJVZ4hyyMe86qroO+rX8U0LXYXovZIYfFSn9CKEuEPGtI+/pJLrlHe5E49j6Jgmog+4Zc35dpOX5QH7rLxPydRMRPCW6+Iu4tsJ6sO2tfZDOeK/j9fTZXxK2C3Q== tchekda@termius"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBLM62vg0tFzObsAm+dojYFqX2yOizoprSIhoMNLJe37QV8XI8BexoYr6W3FgPEtiI5U5U1nCFtt9Pyzmjwcole0AAAAEc3NoOg== contact@tchekda.fr"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9eGPLs+zDFBCUQfwNWkKyELC9EQvaEo1rVRq3TgUXI root@swheeler"
      ];
    };
  };
}
