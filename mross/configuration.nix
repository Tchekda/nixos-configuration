{ pkgs, ... }:
let client_id = builtins.readFile ./client_id;
in {
  imports = [
    ./hardware-configuration.nix
    ../tchekda_user.nix
    <home-manager/nixos>
    (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
    ./seedbox.nix
    ./nginx.nix
    ./wireguard.nix
    ./dn42
    ./hockey-pen-stats.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        splashImage = null;
      };
    };
    tmp.cleanOnBoot = true;
  };

  documentation.enable = false;

  environment = {
    etc."dhcpcd.duid".text = client_id;
    systemPackages = with pkgs; [
      dig
      git
      htop
      iotop
      lnav
      nano
      wget
    ];
  };

  home-manager.users.tchekda = {
    imports = [ ../home-manager/mross/default.nix ];
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  networking = {

    # extraHosts = ''
    #   185.117.154.164 bt.t-ru.org
    # '';

    dhcpcd = {
      extraConfig = ''
        allowinterfaces enp0s20f*
        noarp
        option rapid_commit
        option host_name, routers
        option interface_mtu
        require dhcp_server_identifier
        debug
        clientid "${client_id}"
        noipv6rs
        interface enp0s20f0
        ipv6rs
        ia_pd 1/48 enp0s20f0
        static ip6_address=2001:bc8:2e2a::1/48
      '';

      persistent = true;
    };

    firewall = {
      allowedTCPPorts = [ 1337 1664 ];
      logRefusedConnections = false;
      # extraCommands = ''
      #   iptables -t nat -A OUTPUT -d 188.114.97.2/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination 185.117.154.164:80
      #   iptables -t nat -A OUTPUT -d 188.114.96.2/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination 185.117.154.164:80
      # '';
    };

    hostName = "mross";

    nameservers = [ "51.159.69.156" "51.159.69.162" "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

    tempAddresses = "disabled";

    useDHCP = true;
  };

  programs.fish.enable = true;

  services = {
    endlessh-go = {
      enable = true;
      openFirewall = true;
      port = 22;
    };
    openssh = {
      enable = true;
      ports = [ 9137 ];
    };
    qemuGuest.enable = true;
    vscode-server.enable = true;
  };

  system.stateVersion = "22.11"; # Did you read the comment?

  systemd.services.dhcpcd.preStart = ''
    cp ${pkgs.writeText "duid" client_id} /var/db/dhcpcd/duid
  '';

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

  zramSwap.enable = true;
}
