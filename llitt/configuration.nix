{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../tchekda_user.nix
    <home-manager/nixos>
    <nixos-hardware/raspberry-pi/4>
    ./containers.nix
    ./nginx.nix
    ./dn42
    # (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
  ];

  console.enable = true;

  documentation.enable = false;

  # Generate an immutable /etc/resolv.conf from the nameserver settings
  # above (otherwise DHCP overwrites it):
  environment = {
    etc."resolv.conf" =
      with lib;
      with pkgs;
      {
        source = writeText "resolv.conf" ''
          ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
          options edns0
        '';
      };
    systemPackages = with pkgs; [
      git
      htop
      libraspberrypi
      raspberrypi-eeprom
      nano
      # tcpdump
      wget
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  home-manager.users.tchekda = {
    imports = [ ../home-manager/llitt/default.nix ];
  };

  networking = {
    defaultGateway6 = {
      address = "fe80::de00:b0ff:fe3a:249e";
      interface = "eth0";
    };

    dhcpcd.extraConfig = ''
      interface eth0
      static domain_name_servers=
      nohook resolv.conf
    '';

    enableIPv6 = true;

    firewall.enable = false;

    hostName = "llitt";

    interfaces.eth0 = {
      ipv6.addresses = [
        {
          address = "2a01:e0a:7a:641::1";
          prefixLength = 64;
        }
      ];
    };

    nameservers = [
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];

    resolvconf.enable = false;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-old";
  };

  programs.fish.enable = true;

  services = {
    openssh.enable = true;
    mosquitto = {
      enable = true;
      listeners = [
        {
          address = "0.0.0.0";
          users.tchekda = {
            acl = [ "readwrite #" ];
            hashedPassword = "$6$t/OetPjG29PEKvLc$Vx3CGiLe23IKAWnVGPqFpAbEeIMahC6+wyICKDqPQh1bP0Cu6cHikmmXQMx2uvbZ0E0Bebw/aTnH71R40GJv8A==";
          };
        }
      ];
    };
    # vscode-server.enable = true;
  };

  system.stateVersion = "22.05"; # Did you read the comment?

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

}
