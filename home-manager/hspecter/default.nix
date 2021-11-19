{ pkgs, config, lib, environment, ... }:
let
  unstable = import ../../unstable.nix { config.allowUnfree = true; };
  screenlocker = builtins.fetchurl {
    url = https://wallpapercave.com/wp/wp2732698.jpg;
    sha256 = "sha256:1jspsg2h43lqqav4wp8ikrbm22ynx18479v7a49nsigi4657gln3";
  };
in
{
  imports = [
    ../home.nix
    ../battery.nix
  ];

  home = {
    packages = lib.mkMerge [ (import ../desktop-packages.nix { inherit pkgs unstable; }).packages (import ./packages.nix { inherit pkgs unstable; }).packages ];

    # sessionVariables = {
    #   LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:\${LD_LIBRARY_PATH}";
    # };
  };


  xsession.windowManager.i3 = import ../i3.nix { inherit pkgs lib; };

  programs = {

    alacritty = import ../alacritty.nix { inherit pkgs; };

    autorandr = import ./autorandr.nix { inherit pkgs; };


    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        ms-vscode.cpptools
        ms-vscode-remote.remote-ssh
      ];
    };


    fish = {
      shellAbbrs = lib.mkMerge [
        {
          deletec = "sudo openfortivpn -c /home/tchekda/nixos-configuration/home-manager/hspecter/deletec-vpn";
          ambition = "sudo openfortivpn -c /home/tchekda/nixos-configuration/home-manager/hspecter/ambition-vpn";
          nrs = "sudo nixos-rebuild -I \"nixos-config=/home/tchekda/nixos-configuration/hspecter/configuration.nix\" switch";
          hms = "home-manager -f /home/tchekda/nixos-configuration/home-manager/home.nix switch";
        }
      ];
    };


  };

  services = {

    polybar = import ./polybar.nix { inherit pkgs; };

    dunst = import ../dunst.nix { inherit pkgs unstable; };

    caffeine.enable = true;

    dropbox.enable = true;

    picom = {
      enable = true;
      vSync = true;
      shadow = true;
      shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];
      backend = "glx";
      fade = true;
      fadeDelta = 5;
    };


  };

  systemd.user.services = {

    dropbox.Install.WantedBy = lib.mkForce [ ];

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
