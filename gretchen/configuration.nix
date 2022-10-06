# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ../tchekda_user.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment = {
    gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

    systemPackages = with pkgs; [
      acpi
      git
      gnome.seahorse
      gnupg
      hicolor-icon-theme
      nano
      ntfs3g
      wget
      wireguard-tools
    ];
  };

  hardware = {

    bluetooth = {
      enable = true;
      # hsphfpd.enable = true;
      # package = oldstable.bluezFull; # https://github.com/NixOS/nixpkgs/issues/177311#issuecomment-1154236306
      package = unstable.bluez5-experimental;
      # powerOnBoot = false;
      settings = {
        # A2DP https://nixos.wiki/wiki/Bluetooth#Enabling_A2DP_Sink
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    enableAllFirmware = true; # For wifi : https://github.com/NixOS/nixos-hardware/issues/8
    enableRedistributableFirmware = true;

    firmware = with pkgs; [];

    i2c.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      extraPackages32 = [
      ];
    };

    pulseaudio.enable = false;

    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  home-manager.users.tchekda = {
    programs.home-manager.enable = true;
    home = {
      username = "tchekda";
      homeDirectory = "/home/tchekda";
      packages = [ pkgs.home-manager ];
    };
    imports = [ ../home-manager/gretchen/default.nix ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  location.provider = "geoclue2";
  
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    trustedUsers = [ "root" "tchekda" ];
  };

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
  };

  networking = {
    enableIPv6 = true;

    hostName = "gretchen"; # Define your hostname.

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    useDHCP = lib.mkDefault true;

    wireless.iwd.enable = true;
  };

  programs = {
    dconf.enable = true;
    ssh.startAgent = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };


  # Enable the X11 windowing system.
  services = {
    acpid.enable = true;

    avahi = {
      enable = true;
      nssmdns = true; # Restart nscd in case stops working again
      ipv4 = true;
      ipv6 = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
        workstation = true;
      };
    };

    blueman.enable = true;

    dbus.packages = [ pkgs.gcr ];

    ddccontrol.enable = true;

    fstrim.enable = true;

    fwupd.enable = true;

    geoclue2.enable = true;

    gnome = {
      at-spi2-core.enable = true;
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

    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = false;
      media-session = {
        enable = true;
        config.bluez-monitor.rules = [
          # https://gist.github.com/iwantroca/90eb080ea130e232cbe0d48f3595e846
          {
            # Matches all cards
            matches = [{ "device.name" = "~bluez_card.*"; }];
            actions = {
              "update-props" = {
                "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                # automatically switch between HSP/HFP and A2DP profiles when an input stream is detected https://wiki.archlinux.org/title/PipeWire
                "bluez5.autoswitch-profile" = false; # Because now internal mic works
                # mSBC is not expected to work on all headset + adapter combinations.
                "bluez5.msbc-support" = true;
                # SBC-XQ is not expected to work on all headset + adapter combinations.
                "bluez5.sbc-xq-support" = true;
              };
            };
          }
          {
            matches = [
              # Matches all sources
              { "node.name" = "~bluez_input.*"; }
              # Matches all outputs
              { "node.name" = "~bluez_outpuft.*"; }
            ];
            actions = {
              "node.pause-on-idle" = true;
            };
          }
        ];
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 pkgs.gutenprint pkgs.hplipWithPlugin ];
    };

    redshift.enable = true;

    tlp = {
      enable = false; # Linux Advanced Power Management : Kills some usb controllers, will need to figure out a solution
      settings = {
        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
        TLP_DEBUG = "arg bat disk lock nm path pm ps rf run sysfs udev usb";
      };
    };

    tzupdate.enable = true;

    xserver = {
      enable = true;

      deviceSection = ''
        Option "DRI" "3"
        Option "TearFree" "true"
      '';

      displayManager.sddm.enable = true;
      desktopManager.gnome.enable = true;

      inputClassSections = [
        ''
          Identifier "mouse accel"
          Driver "libinput"
          MatchIsPointer "on"
          Option "AccelProfile" "flat"
          Option "AccelSpeed" "0"
        ''
      ];

      layout = "us";

      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          accelProfile = "flat";
          disableWhileTyping = true;
        };
      };

      useGlamor = true;

      videoDrivers = [ "nvidia" ];

      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
          extraSessionCommands = ''
            eval $(${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --daemonize)
            export SSH_AUTH_SOCK
          '';
        };
      };

      xkbVariant = "altgr-intl";


    };

  };

  sound.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?

  systemd = {
    sleep.extraConfig = "HibernateDelaySec=30m";

    services = {
      # Disable autostarts
      cups-browsed.wantedBy = lib.mkForce [ ];
      NetworkManager-wait-online.enable = false;
      # wg-quick-wg0.wantedBy = lib.mkForce [ ];
    };

    user.services.geoclue-agent.wantedBy = [ "network.target" ];
  };

  time.hardwareClockInLocalTime = true;

  users.users = {
    tchekda.extraGroups = [ "audio" "networkmanager" "lpadmin" "scanner" "lp" "video" "i2c" ];
    root.shell = pkgs.fish;
  };
}
