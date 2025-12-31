{
  config,
  pkgs,
  lib,
  unstable,
  ...
}:
let
  dcpj515wDriver = pkgs.callPackage ./dcpj515w.nix { };
in
{
  imports = [
    ./hardware-configuration.nix
    # <home-manager/nixos> # Config split between system and user
    # nixos-hardware module now imported via flake.nix
    ../tchekda_user.nix
    ./dev.nix
    ./sane-extra-config.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      ddcci-driver
    ];

    extraModprobeConfig = ''
      options iwlwifi 11n_disable=8 power_save=1 uapsd_disable=1
      options thinkpad_acpi fan_control=1
      options snd_hda_intel power_save=0
    '';

    kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.route.max_size" = 8388608;
      "vm.swappiness" = 1;
    };

    kernelModules = [
      "acpi_call"
      # "amdgpu"
      "ddcci_backlight"
      "hid_logitech_hidpp"
      "i2c-dev"
      "kvm-amd"
      "psmouse"
      "thinkpad_acpi"
      "vfio-pci"
    ];

    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    # https://github.com/pop-os/pop/issues/782#issuecomment-571700843
    kernelParams = [
      "acpi_backlight=native"
      # "amdgpu.backlight=0"
      # "amdgpu.noretry=0"
      "mem_sleep_default=deep"
      "psmouse.synaptics_intertouch=0"
    ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      enable = true;
      # kernelModules = [ "amdgpu" ];
      availableKernelModules = [ "thinkpad_acpi" ];
    };

  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  documentation.man.generateCaches = false;

  environment = {
    extraOutputsToInstall = [
      "out"
      "lib"
      "bin"
      "dev"
    ];
    pathsToLink = [
      "/include"
      "/lib"
    ];
    etc."chromium/policies/recommended/spnego.json".text = builtins.toJSON {
      AuthServerWhitelist = "cri.epita.fr";
    };

    # etc = {
    #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
    #     bluez_monitor.properties = {
    #         ["bluez5.enable-sbc-xq"] = true,
    #         ["bluez5.enable-msbc"] = true,
    #         ["bluez5.enable-hw-volume"] = true,
    #         ["bluez5.codecs"] = "[ sbc sbc_xq aac ldac aptx aptx_hd aptx_ll aptx_ll_duplex faststream faststream_duplex ]",
    #         ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
    #         ["with-logind"] = true,
    #     }
    #   '';
    # };

    gnome.excludePackages = (
      with pkgs;
      [
        atomix # puzzle game
        cheese # webcam tool
        baobab
        decibels # music player
        epiphany # web browser
        evince # document viewer
        geary # email reader
        gnome-backgrounds
        gnome-calendar
        gnome-characters
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-music
        gnome-photos
        gnome-software
        gnome-terminal
        gnome-text-editor
        gnome-tour
        gnome-user-docs
        gnome-weather
        gedit # text editor
        hitori # sudoku game
        orca
        iagno # go game
        snapshot
        tali # poker game
        totem # video player
        showtime # video player
        yelp
      ]
    );

    systemPackages = with pkgs; [
      acpi
      git
      seahorse
      adwaita-icon-theme
      gnome-tweaks
      gnomeExtensions.appindicator
      gnupg
      home-manager
      nano
      ntfs3g
      wget
      wireguard-tools
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
    };
    variables = {
      # MUTTER_DEBUG = "kms";
      # MUTTER_DEBUG_DISABLE_TRIPLE_BUFFERING = "1";
      # MUTTER_DEBUG_ENABLE_ATOMIC_KMS = "0";
    };
  };

  # fileSystems."/mnt/fbx" = {
  #   device = "//192.168.2.254/Freebox";
  #   fsType = "cifs";
  #   options =
  #     let
  #       # this line prevents hanging on network split
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

  #     in
  #     [ "${automount_opts},credentials=/home/tchekda/nixos-configuration/hspecter/smb-secrets" ];
  # };

  hardware = {

    amdgpu = {
      #   amdvlk = {
      #     enable = true;
      #     support32Bit.enable = true;
      #   };
      initrd.enable = false;
      #   opencl.enable = true;
    };

    bluetooth = {
      enable = true;
      # hsphfpd.enable = true;
      package = pkgs.bluez5-experimental;
      # powerOnBoot = false;
      settings = {
        # A2DP https://nixos.wiki/wiki/Bluetooth#Enabling_A2DP_Sink
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    cpu.amd.updateMicrocode = true;

    enableAllFirmware = true; # For wifi : https://github.com/NixOS/nixos-hardware/issues/8
    enableRedistributableFirmware = true;

    firmware = with pkgs; [
      linux-firmware
      sof-firmware
    ];

    i2c.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    graphics = {
      enable32Bit = true;
      extraPackages = with pkgs; [
        # amdvlk
        mesa
        # rocm-opencl-icd
        # rocm-opencl-runtime
      ];
      extraPackages32 = [
        # pkgs.driversi686Linux.amdvlk
      ];

    };

    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  # Disabled so we don't rebuild all user packages on system upgrade
  # home-manager = {
  #   extraSpecialArgs = { inherit unstable; };
  #   # useGlobalPkgs = true;
  #   # useUserPackages = true;
  #   users.tchekda = {
  #     programs.home-manager.enable = true;
  #     home = {
  #       username = "tchekda";
  #       homeDirectory = "/home/tchekda";
  #       packages = [ pkgs.home-manager ];
  #     };
  #     imports = [ ../home-manager/hspecter/default.nix ];
  #   };
  # };

  i18n.defaultLocale = "en_US.UTF-8";

  location = {
    provider = "geoclue2";
    # provider = "manual";
    # latitude = 32.794044;
    # longitude = 34.989571;
  };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    settings = {
      trusted-users = [
        "root"
        "tchekda"
      ];
      # substituters = [ "http://cache.nixos.org" "http://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr" ];
      # trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo=" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  networking = {
    hostName = "hspecter";

    enableIPv6 = true;

    firewall = {
      enable = false;
      allowPing = true;
      allowedTCPPorts = [
        # Spotify
        57621
        57622
      ];
      allowedUDPPorts = [
        # Spotify
        57621
        57622
      ];
      checkReversePath = false; # https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_with_NetworkManager
    };

    wireless.iwd.enable = true;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  programs = {
    adb.enable = true;

    command-not-found.enable = true;

    # gnupg.agent = {
    #   enable = true;
    #   enableExtraSocket = true;
    # };
    dconf.enable = true;

    fish.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc # commonly needed
        zlib # commonly needed
        openssl # commonly needed
      ];
    };

    # ssh.startAgent = true;

    wireshark = {
      enable = false;
      package = pkgs.wireshark;
    };

    xwayland.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  security = {
    polkit.enable = true;
    pam.services = {
      i3lock-color = {
        fprintAuth = true;
        u2fAuth = true;
      };
      i3lock = {
        fprintAuth = true;
        u2fAuth = true;
      };
      login = {
        fprintAuth = lib.mkForce true;
        u2fAuth = true;
      };
      sddm = {
        fprintAuth = true;
        u2fAuth = true;
      };
      sudo = {
        fprintAuth = true;
        u2fAuth = true;
      };
      xscreensaver = {
        fprintAuth = true;
        u2fAuth = true;
      };
    };
    rtkit.enable = true;
    wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+x,o+x";
    };
  };

  services = {
    acpid.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true; # Restart nscd in case stops working again
      nssmdns6 = true; # Restart nscd in case stops working again
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

    desktopManager.gnome = {
      enable = true;
      sessionPath = with pkgs; [
        gnome-shell-extensions
      ];
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    dbus.packages = with pkgs; [
      gcr
      gnome2.GConf
    ];

    fprintd.enable = true;

    fstrim.enable = true;

    fwupd.enable = true;

    geoclue2 = {
      enable = true;
      # geoProviderUrl = "https://location.services.mozilla.com/v1/geolocate?key=16674381-f021-49de-8622-3021c5942aff";
    };

    gnome = {
      at-spi2-core.enable = true;
    };

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        accelProfile = "flat";
        disableWhileTyping = true;
      };
    };

    logind = {
      settings.Login.HandleLidSwitch = "suspend";
    };

    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # media-session = {
      #   enable = false;
      #   config.bluez-monitor.rules = [
      #     # https://gist.github.com/iwantroca/90eb080ea130e232cbe0d48f3595e846
      #     {
      #       # Matches all cards
      #       matches = [{ "device.name" = "~bluez_card.*"; }];
      #       actions = {
      #         "update-props" = {
      #           "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
      #           "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
      #           # automatically switch between HSP/HFP and A2DP profiles when an input stream is detected https://wiki.archlinux.org/title/PipeWire
      #           "bluez5.autoswitch-profile" = false; # Because now internal mic works
      #           # mSBC is not expected to work on all headset + adapter combinations.
      #           "bluez5.msbc-support" = true;
      #           # SBC-XQ is not expected to work on all headset + adapter combinations.
      #           "bluez5.sbc-xq-support" = true;
      #         };
      #       };
      #     }
      #     {
      #       matches = [
      #         # Matches all sources
      #         { "node.name" = "~bluez_input.*"; }
      #         # Matches all outputs
      #         { "node.name" = "~bluez_outpuft.*"; }
      #       ];
      #       actions = {
      #         "node.pause-on-idle" = true;
      #       };
      #     }
      #   ];
      # };
    };

    printing = {
      drivers = [
        pkgs.cnijfilter2
        pkgs.gutenprint
        pkgs.hplipWithPlugin
        # dcpj515wDriver.driver
        # dcpj515wDriver.cupswrapper
      ];
      enable = true;
      logLevel = "error";
    };

    pulseaudio.enable = false;

    pcscd.enable = true;

    redshift.enable = false;

    # teamviewer.enable = true;

    thinkfan = {
      enable = true;
      sensors = [
        # {
        #   type = "chip";
        #   query = "thinkpad-isa-0000";
        #   ids = [ "CPU" ];
        # }
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/thermal";
          indices = [ 0 ];
        }
      ];
      levels = [
        [
          "level auto"
          0
          45
        ]
        [
          7
          40
          95
        ]
        [
          "level disengaged"
          90
          255
        ]
      ];
    };

    tlp = {
      # Incompatible with Gnome
      enable = false; # Linux Advanced Power Management : Kills some usb controllers, will need to figure out a solution
      settings = {
        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
        TLP_DEBUG = "arg bat disk lock nm path pm ps rf run sysfs udev usb";
      };
    };

    tzupdate.enable = true;

    udev.packages = with pkgs; [
      yubikey-personalization
      gnome-settings-daemon
    ];

    xserver = {
      enable = true;

      deviceSection = ''
        Option "DRI" "3"
        Option "TearFree" "false"
      '';

      # displayManager.sddm.enable = true;

      # extraConfig = ''
      #   Section "OutputClass"
      #     Identifier "AMDgpu"
      #     MatchDriver "amdgpu"
      #     Driver "amdgpu"
      #     Option "TearFree" "false"
      #   EndSection
      # '';

      inputClassSections = [
        ''
          Identifier "mouse accel"
          Driver "libinput"
          MatchIsPointer "on"
          Option "AccelProfile" "flat"
          Option "AccelSpeed" "0"
        ''
      ];

      # useGlamor = true;

      videoDrivers = [ "modesetting" ];

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };

    };

  };

  system = {
    stateVersion = "21.05";
  };

  systemd = {

    services = {
      # Disable autostarts
      cups-browsed.wantedBy = lib.mkForce [ ];
      nginx.wantedBy = lib.mkForce [ ];
      mysql.wantedBy = lib.mkForce [ ]; # prevent corruptions happening on hard shutdown
      postgresql.wantedBy = lib.mkForce [ ]; # prevent corruptions happening on hard shutdown
      redis.wantedBy = lib.mkForce [ ]; # prevent corruptions happening on hard shutdown
      NetworkManager-wait-online.enable = false;
      wg-quick-wg0.wantedBy = lib.mkForce [ ];
    };

    user.services.geoclue-agent.wantedBy = [ "network.target" ];
  };

  time = {
    # timeZone = "Europe/Paris"; # Defined by tzdata service
    hardwareClockInLocalTime = true;
  };

  users = {
    users = {
      tchekda.extraGroups = [
        "adbusers"
        "docker"
        "audio"
        "networkmanager"
        # "libvirtd"
        "lpadmin"
        "scanner"
        "lp"
        "video"
        "i2c"
      ];
      root.shell = pkgs.fish;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        features = {
          buildkit = true;
        };
      };
    };

    libvirtd = {
      enable = false;
      onBoot = "ignore";
      # qemu.package = pkgs.qemu_kvm.override { smbdSupport = true; };
    };
  };
}
