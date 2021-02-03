{ pkgs, config, lib, environment, ... }:
let
  unstable = import ../../unstable.nix { config.allowUnfree = true; };
  screenlocker = builtins.fetchurl {
    url = https://wallpapercave.com/wp/wp2732698.jpg;
    sha256 = "18i26c2szmsas9r962ndncikp2lzqljg9rr4v2szp03hfp2sah0q";
  };
in
{

  home.packages = lib.mkMerge [ (import ../desktop-packages.nix { inherit pkgs unstable; }).packages (import ./packages.nix { inherit pkgs unstable; }).packages ];

  imports = [
    ../battery.nix
  ];

  xsession.windowManager.i3 = import ../i3.nix { inherit pkgs lib; };

  programs = {

    autorandr = import ./autorandr.nix { inherit pkgs; };

  };

  services = {

    polybar = import ./polybar.nix { inherit pkgs; };

    dunst = import ../dunst.nix { inherit pkgs unstable; };

    caffeine.enable = true;

    dropbox.enable = true;

  };

  systemd.user.services = {

    xautolock = {
      Unit = {
        Description = "xautolock, session locker service";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = ''
          ${pkgs.xautolock}/bin/xautolock -noclose -detectsleep -time 15 \
           -locker "${pkgs.i3lock-color}/bin/i3lock-color -ti ${screenlocker} \
           --clock --pass-media-keys --pass-screen-keys --pass-power-keys --pass-volume-keys" \
           -notifier "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds'" -notify 10 \
           -killer "/run/current-system/systemd/bin/systemctl hibernate" -killtime 30
        '';
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
