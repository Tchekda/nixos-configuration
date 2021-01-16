{ config, pkgs, lib, ... }:
let
  unstable = import ../unstable.nix { config.allowUnfree = true; };

in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./dev.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        device = "nodev";
        enableCryptodisk = true;
      };
    };
    kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
    };
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  fileSystems."/home".options = [ "noatime" "nodiratime" "discard" ];

  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-uuid/13a5c949-6966-4a84-9392-4981124fd71a";
    preLVM = true;
    allowDiscards = true;
  };

  networking = {
    hostName = "hspecter";

    interfaces = {
      # enp2s0f0.useDHCP = true;
      enp5s0 = {
        useDHCP = true;
        ipv4.routes = [
          { address = "172.20.0.0"; prefixLength = 14; via = "192.168.2.253"; }
        ];
      };
      wlp3s0.useDHCP = true;
    };
    wireless = {
      enable = true;
    };

    firewall = {
      allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
    };

    # wg-quick.interfaces = {
    #   pve-vpn = {
    #     address = [ "192.168.1.153/32" "2001:bc8:2e2a:103::4/128" ];
    #     dns = [ "192.168.1.102" "1.1.1.1" ];
    #     privateKeyFile = "/home/tchekda/nixos-config/hspecter/wireguard-keys/wg.priv";
    #     listenPort = 51820;

    #     peers = [
    #       {
    #         publicKey = "wTSqfeMNBukTRrQKz+ZyDErN9tqUjttXua9iExJwIg0=";
    #         allowedIPs = [ "0.0.0.0/0" "::/0" ];
    #         # allowedIPs = [ "192.168.1.0/24" ];
    #         endpoint = "[2001:bc8:2e2a:103::1]:51820";
    #         # endpoint = "163.172.50.165:51820";
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
  };

  time.timeZone = "Europe/Paris";

  nix.gc = {
    automatic = true;
    dates = "22:15";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    xserver = {
      enable = true;

      layout = "us";
      xkbVariant = "altgr-intl";

      xautolock = {
        enable = true;
        locker = "${pkgs.i3lock-color}/bin/i3lock-color -c 1e272e --clock";
        nowlocker = "${pkgs.i3lock-color}/bin/i3lock-color -c 1e272e --clock";
      };

      inputClassSections = [
        ''
          Identifier "mouse accel"
          Driver "libinput"
          MatchIsPointer "on"
          Option "AccelProfile" "flat"
          Option "AccelSpeed" "0"
        ''
      ];

      libinput = {
        enable = true;
        naturalScrolling = true;
        accelProfile = "flat";
        disableWhileTyping = true;
        additionalOptions = ''MatchIsTouchpad "on"'';
      };

      displayManager = {
        sddm.enable = true;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "ignore";
      lidSwitchDocked = "ignore";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        HandleSuspendKey=ignore
      '';
    };

    acpid.enable = true;

    fprintd.enable = true;

    openssh.enable = true;

    fwupd.enable = true;

    blueman.enable = true;

    thinkfan = {
      enable = true;
      sensors = ''
        tp_thermal /proc/acpi/ibm/thermal (0, 0, 0, 0, 0, 0, 0, 0)
      '';
      levels = ''
        ("level auto",     0,      55)
        (1,     48,     60)
        (2,     50,     61)
        (3,     55,     65)
        (4,     55,     65)
        (5,     60,     70)
        (6,     65,     80)
        (7,     77,     85)
      '';
    };


  };

  systemd = {
    sleep.extraConfig = "HibernateDelaySec=30m";

    # services.wg-quick-pve-vpn.wantedBy = [];
  };

  programs = {
    gnupg.agent = {
      enable = true;

      # enableSSHSupport = true;
      enableExtraSocket = true;
    };

    ssh.startAgent = true;

    fish.enable = true;
  };
  sound.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  users.users.tchekda = {
    description = "David Tchekachev";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+Shk2GUm7qNih/ynWNowbABxPzC9cl6FrcmFe713GmSk+q9eXVDhqbQ9zKlwfU56pK2cXUjukMP21L8vgX9raSze7MY1cBHJ9FzuTWqNrfcDguf80oqIXIcwzITEbOOk/unXcLQHsbBx33ydIg5SCLvpXs7AIs9v2kBrtRkv4W01muJHtHICRYvM3PlDsZeevhd7cEIzLJvB03clUUomTJTSWd3csFYk7mCRiJcvvQ3buxyXMPvwS528Zwp+qZSSq2dPLJZ+QOx3CpNF9XN+TswePdMqibi5a3R3AA4Rz/XoUOxDK46uJNBoudzDhjT79UAIawG4utaELeENWi4vyfyMTs5YOG8Q/5p74ibkbdyoXfsJzX8+bGfPQcvpk02uyXpz/qijjn81G01ssix8ebjNL2OaD6K7gme8Y5QIwonw/Dlk9NXvBSf5l/GTmZLaPLyPjo0Ag9LrZ4HZEPdP4t8xaKXrkwZi1LPDZkK3OkaNR4EwuBEXbvCbN8ITgoAlIIrUNnU2Y6bJ9/12AdOcrHIWwcbejrxHMXkZTrTPXYZ2P0nRCXD6NO2wKWRGUJJMQit5mSY0B+lRkDo/uA5SaDo9sSfWMsY7FvsKoM6rdrq2nUKOeZTkk553XgoxlKHSHMDh1y7SxKKgG1IScjY6AePXQEJD0A5grrrdfkQoy+w==" ];
  };

  home-manager.users.tchekda = import ../home-manager/home.nix;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    nano
    git
    gnupg
    libnotify
  ];

  virtualisation.docker.enable = true;

  system.stateVersion = "20.09"; # Did you read the comment?
}
