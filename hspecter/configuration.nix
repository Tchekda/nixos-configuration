{ config, pkgs, lib, ... }:
let
  unstable = import ../unstable.nix { config.allowUnfree = true; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./dev.nix
      ./sane-extra-config.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi.canTouchEfiVariables = true;
    };

    extraModulePackages = with config.boot.kernelPackages; [ acpi_call rtw89 ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.route.max_size" = 8388608;
    };

    kernelModules = [ "kvm-amd" "vfio-pci" "acpi_call" "thinkpad_acpi" ];

    extraModprobeConfig = ''
      options snd_acp3x_rn dmic_acpi_check=1
    '';

    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    kernelParams = [ "amdgpu.backlight=0" "acpi_backlight=none" "thinkpad_acpi.fan_control=1" ];

    initrd = {
      enable = true;
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [ "thinkpad_acpi" ];
    };
  };

  networking = {
    hostName = "hspecter";

    enableIPv6 = true;

    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPorts = [ 51820 ];
      checkReversePath = false; # https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_with_NetworkManager
    };

    wireless.iwd.enable = true;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  time = {
    # timeZone = "Europe/Paris"; # Defined by tzdata service
    hardwareClockInLocalTime = true;
  };

  location = {
    # provider = "geoclue2";
    provider = "manual";
    latitude = 48.8582;
    longitude = 2.3387;
  };

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
        # sessionCommands = ''
        #   ${config.systemd.package}/bin/systemctl --user import-environment
        # '';
      };


      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 pkgs.gutenprint pkgs.hplipWithPlugin ];
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

    thinkfan =
      {
        enable = true;
        # smartSupport = true; # No HDD
        # fans = [
        #   {
        #     query = "/proc/acpi/ibm/fan";
        #     type = "tpacpi";
        #   }
        #   # {
        #   #   query = "/sys/class/hwmon/hwmon2/pwm1";
        #   #   type = "hwmon";
        #   # }
        # ];
        sensors = [
          {
            type = "tpacpi";
            query = "/proc/acpi/ibm/thermal";
            indices = [ 0 ];
          }
        ];
        levels = [
          [ 0 0 55 ]
          [ 1 50 60 ]
          [ 2 55 65 ]
          [ 3 60 70 ]
          [ 6 65 75 ]
          [ 7 70 80 ]
          [ "level full-speed" 75 32767 ]
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

    geoclue2.enable = false;

    redshift.enable = true;

    tzupdate.enable = true;

    tlp = {
      enable = false; # Linux Advanced Power Management : Kills some usb controllers, will need to figure out a solution
      settings = {
        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
        USB_AUTOSUSPEND = 0;
      };
    };
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
    cpu.amd.updateMicrocode = true;
    enableAllFirmware = true; # For wifi : https://github.com/NixOS/nixos-hardware/issues/8
    firmware = with pkgs; [ sof-firmware rtw89-firmware ];
    enableRedistributableFirmware = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      configFile = pkgs.runCommand "default.pa" { } ''
        grep -v module-role-cork ${config.hardware.pulseaudio.package}/etc/pulse/default.pa > $out
      '';
      extraConfig = "
        load-module module-switch-on-connect
        load-module module-bluetooth-policy
        load-module module-bluetooth-discover
      ";
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        # A2DP https://nixos.wiki/wiki/Bluetooth#Enabling_A2DP_Sink
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAzZARI4tFaQ1T2g5Ug63IXpoLlKYTqnBoja/wam/+QsVH2I4/9t/LBS675+xWJ55UdTpxhkcHYplcvdR4PB3gR5rK/Eqqv7lZEpyriarfdiBuOS0XBYJANpDsGuzeAU7SPL2Kxn8FyWMxqQZeCHyO5fTXhOAUhay5C7n0ym7Ep1Lck3l9eT+sNOPNa5F+bnWheeQG4HkueBiSqt1nUCZA1NQnyvBAFP439/oNVkBXe5q/63eSuDdbq45h5HgR8512HZO857oceLql6PFWIhaG0eF0ifgwqcbNN7iNJ3wFUigb/nR0WZgJwLdUxzUIWyLZz/7Lwn+RatKIL/uicfb/ tchekda@Tchekda" # ASUS computer
    ];
  };

  home-manager.users.tchekda = import
    ../home-manager/home.nix;


  environment.systemPackages = with pkgs; [
    wget
    nano
    git
    gnupg
    acpi
  ];

  security = {
    polkit.enable = true;
    pam.services = {
      login.fprintAuth = true;
      xscreensaver.fprintAuth = true;
    };
  };

  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemuPackage = pkgs.qemu_kvm.override { smbdSupport = true; };
    };
  };
  system.stateVersion = "21.05";
}
