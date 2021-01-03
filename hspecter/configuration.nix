{ config, pkgs, lib, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/eef90463b3478020bdfcefa5c0d718d3380e635d)
    { config = config.nixpkgs.config; };
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
      enp2s0f0.useDHCP = true;
      enp5s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
    wireless = {
      enable = true;
      userControlled.enable = true;
      networks = import ./wireless.nix;
    };
  };

  time.timeZone = "Europe/Paris";

  nix.gc = {
    automatic = true;
    dates = "03:15";
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
        # extraOptions = ["-lockaftersleep"];
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

    printing.enable = true;

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

  };

  systemd = {
    sleep.extraConfig = "HibernateDelaySec=1h";
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
    bluetooth.enable = true;
  };

  users.users.tchekda = {
    description = "David Tchekachev";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "www-data" ];
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
