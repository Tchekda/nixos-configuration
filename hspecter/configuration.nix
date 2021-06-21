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
      ./sane-extra-config.nix
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
        theme = pkgs.nixos-grub2-theme;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        enableCryptodisk = true;
        extraConfig = ''
          snd_rn_pci_acp3x.dmic_acpi_check=1
          acpi_backlight=vendor
        '';
      };
    };

    extraModulePackages = with config.boot.kernelPackages; [ acpi_call tp_smapi ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.route.max_size" = 8388608;
    };
    kernelModules = [ "kvm-amd" "vfio-pci" "acpi_call" "tp_smapi" ];

    extraModprobeConfig = ''
      options snd_acp3x_rn dmic_acpi_check=1
    '';

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

    enableIPv6 = true;

    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [ 51820 ];
    };

    wireless.iwd.enable = true;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    wg-quick.interfaces = {
      wg0 = {
        address = [ "192.168.1.153/32" "2001:bc8:2e2a:103::4/128" ];
        dns = [ "2001:bc8:2e2a:102::1" "2606:4700:4700::1111" "192.168.1.102" "1.1.1.1" ];
        privateKeyFile = "/home/tchekda/nixos-config/hspecter/wireguard-keys/wg.priv";

        peers = [
          {
            publicKey = "wTSqfeMNBukTRrQKz+ZyDErN9tqUjttXua9iExJwIg0=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "163.172.50.165:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # time.timeZone = "Europe/Paris"; Because services.tzupdate is enabled

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {

    gnome = {
      at-spi2-core.enable = true;
      gnome-keyring.enable = true;
    };

    xserver = {
      enable = true;

      videoDrivers = [ "amdgpu" ];

      deviceSection = ''
        Option "DRI" "3"
        Option "TearFree" "true"
      '';
      useGlamor = true;


      layout = "us";
      xkbVariant = "altgr-intl";

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
        touchpad = {
          naturalScrolling = true;
          accelProfile = "flat";
          disableWhileTyping = true;
          additionalOptions = ''MatchIsTouchpad "on"'';
        };
      };

      displayManager = {
        sddm.enable = true;
        sessionCommands = ''
          ${config.systemd.package}/bin/systemctl --user import-environment
        '';
      };

      desktopManager.gnome.enable = true;

      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
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

    autorandr.enable = true;

    thinkfan = {
      enable = true;
      smartSupport = true;
      sensors = [
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/thermal";
        }
        {
          type = "hwmon";
          query = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp1_input";
        }
        {
          type = "hwmon";
          query = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp2_input";
        }
        {
          type = "hwmon";
          query = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp3_input";
        }
        {
          type = "hwmon";
          query = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp4_input";
        }
        {
          type = "hwmon";
          query = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp5_input";
        }
        {
          type = "hwmon";
          query = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon4/temp6_input";
        }
      ];
      levels = [
        [ 0 0 55 ]
        [ 1 48 60 ]
        [ 2 50 61 ]
        [ 3 52 63 ]
        [ 6 56 65 ]
        [ 7 60 85 ]
        [ "level auto" 80 32767 ]
      ];
    };

    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
        workstation = true;
      };
    };

    geoclue2.enable = true;

    tzupdate.enable = true;
  };

  systemd = {
    sleep.extraConfig = "HibernateDelaySec=30m";

    services = {
      wg-quick-wg0.wantedBy = lib.mkForce [ ];
      NetworkManager-wait-online.enable = false;
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableExtraSocket = true;
    };

    ssh.startAgent = true;

    fish.enable = true;

    dconf.enable = true;
  };

  sound.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      configFile = pkgs.runCommand "default.pa" { } ''
        grep -v module-role-cork ${config.hardware.pulseaudio.package}/etc/pulse/default.pa > $out
      '';
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    firmware = [ pkgs.sof-firmware ];

    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };

    opengl = {
      driSupport = true;
      extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    };
  };

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
  };

  users.users.tchekda = {
    description = "David Tchekachev";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "docker" "audio" "networkmanager" "libvirtd" "lpadmin" "scanner" "lp" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+Shk2GUm7qNih/ynWNowbABxPzC9cl6FrcmFe713GmSk+q9eXVDhqbQ9zKlwfU56pK2cXUjukMP21L8vgX9raSze7MY1cBHJ9FzuTWqNrfcDguf80oqIXIcwzITEbOOk/unXcLQHsbBx33ydIg5SCLvpXs7AIs9v2kBrtRkv4W01muJHtHICRYvM3PlDsZeevhd7cEIzLJvB03clUUomTJTSWd3csFYk7mCRiJcvvQ3buxyXMPvwS528Zwp+qZSSq2dPLJZ+QOx3CpNF9XN+TswePdMqibi5a3R3AA4Rz/XoUOxDK46uJNBoudzDhjT79UAIawG4utaELeENWi4vyfyMTs5YOG8Q/5p74ibkbdyoXfsJzX8+bGfPQcvpk02uyXpz/qijjn81G01ssix8ebjNL2OaD6K7gme8Y5QIwonw/Dlk9NXvBSf5l/GTmZLaPLyPjo0Ag9LrZ4HZEPdP4t8xaKXrkwZi1LPDZkK3OkaNR4EwuBEXbvCbN8ITgoAlIIrUNnU2Y6bJ9/12AdOcrHIWwcbejrxHMXkZTrTPXYZ2P0nRCXD6NO2wKWRGUJJMQit5mSY0B+lRkDo/uA5SaDo9sSfWMsY7FvsKoM6rdrq2nUKOeZTkk553XgoxlKHSHMDh1y7SxKKgG1IScjY6AePXQEJD0A5grrrdfkQoy+w==" ];
  };

  home-manager.users.tchekda = import ../home-manager/home.nix;


  environment.systemPackages = with pkgs; [
    wget
    nano
    git
    gnupg
    gnome3.adwaita-icon-theme
    gnomeExtensions.appindicator
    gnome3.gnome-settings-daemon
  ];

  security.polkit.enable = true;

  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemuPackage = pkgs.qemu_kvm.override { smbdSupport = true; };
    };
  };
  system.stateVersion = "20.09";
}
