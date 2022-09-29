{ pkgs, config, lib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "bottom";
      height = 30;
      spacing = 4;
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];
      modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "backlight" "keyboard-state" "battery" "battery#bat2" "clock" "tray" ];
      "sway/workspaces" = {
        all-outputs = true;
      };
      "keyboard-state" = {
        numlock = true;
        capslock = true;
        format = "{name} {icon}";
        format-icons = {
          locked = "";
          unlocked = "";
        };
      };
      "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };
      "idle_inhibitor" = {
        format = "{name}/{icon}";
        format-icons = {
          locked = "💤";
          unlocked = "☕";
        };
      };
      "tray" = {
        spacing = 10;
      };
      "clock" = {
        tooltip-format = "<big>{%OH}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
      };
    };
  };
}
