{ pkgs, config, lib, environment, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  screenlocker = builtins.fetchurl {
    url = https://files.tchekda.fr/suits-wallpaper.jpg;
    sha256 = "sha256:18i26c2szmsas9r962ndncikp2lzqljg9rr4v2szp03hfp2sah0q";
  };
in
{
  imports = [
    ../home.nix
    ../battery.nix
    ../desktop-packages.nix
    ../alacritty.nix
    ../i3.nix
    ../dunst.nix
  ];

  home = {
    sessionPath = [
      "/home/tchekda/.yarn/bin"
    ];
    sessionVariables = {
      HTTPSTAT_SAVE_BODY = "false";
    };
  };

  programs = {

    home-manager.enable = true;

    fish = {
      shellAbbrs =
        {
          nrs = "sudo nixos-rebuild -I \"nixos-config=/home/tchekda/nixos-configuration/gretchen/configuration.nix\" switch";
          hms = "home-manager -f /home/tchekda/nixos-configuration/home-manager/gretchen/default.nix switch -b backup";
        };
    };

    ssh.extraOptionOverrides = {
      "IdentityFile" = "~/.ssh/id_ecdsa_sk";
    };

    vscode = {
      enable = true;
      package = pkgs.vscode;
    };
  };

  services = {

    caffeine.enable = true;

    # dropbox.enable = true;

    gnome-keyring.enable = true;

    gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      pinentryFlavor = "tty";
    };

    mpris-proxy.enable = true;

    picom = {
      enable = false;
      vSync = true;
      shadow = true;
      shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];
      backend = "glx";
      fade = true;
      fadeDelta = 5;
    };
  };

  systemd.user.services = {

    # dropbox.Install.WantedBy = lib.mkForce [ ];

    xautolock = {
      Unit = {
        Description = "xautolock, session locker service";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = ''
          ${pkgs.xautolock}/bin/xautolock -noclose -detectsleep -time 60 \
           -locker "${pkgs.i3lock-color}/bin/i3lock-color -ti ${screenlocker} \
           --clock --pass-media-keys --pass-screen-keys --pass-power-keys --pass-volume-keys" \
           -notifier "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds'" -notify 30 \
        '';
        # -killer "/run/current-system/systemd/bin/systemctl hibernate" -killtime 15
        Restart = "on-failure";
      };
    };

    xss-lock = {
      Unit = {
        Description = "xss-lock, session locker service";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        Environment = "XDG_SESSION_TYPE=x11";
        ExecStart = "${pkgs.xss-lock}/bin/xss-lock -l -s \${XDG_SESSION_ID} -- ${pkgs.xautolock}/bin/xautolock -locknow";
      };
    };
  };


}
