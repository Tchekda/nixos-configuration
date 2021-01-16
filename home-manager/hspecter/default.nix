{ pkgs, config, lib, environment, ... }:
let
  unstable = import ../../unstable.nix { config.allowUnfree = true; };
in
{

  home.packages = lib.mkMerge [ (import ../desktop-packages.nix { inherit pkgs unstable; }).packages (import ./packages.nix { inherit pkgs unstable; }).packages ];

  imports = [
    ../battery.nix
  ];

  programs = {

    autorandr = import ./autorandr.nix { inherit pkgs; };

  };

  services = {

    polybar = import ./polybar.nix { inherit pkgs; };

    dunst = import ../dunst.nix { inherit pkgs unstable; };

    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color -c 1e272e --clock";
    };

    blueman-applet.enable = true;

  };

  systemd.user.services = {

    caffeine-ng = {
      Unit = {
        Description = "Caffeine-ng, a locker inhibitor";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
      };
    };
  };

  xsession.windowManager.i3 = import ../i3.nix { inherit pkgs lib; };

}
