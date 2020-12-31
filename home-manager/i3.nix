{ pkgs, lib, ... }:

let
    wallpaper = builtins.fetchurl {
      url = https://images.pexels.com/photos/2131614/pexels-photo-2131614.jpeg;
      sha256 = "1mgfdbh74vjkpab487c7g6r350wk48a4kv2125lh0i3bdvl710j6";
    };
in
{
  enable = true;
  package = pkgs.i3-gaps;
  
  config = rec {
    modifier = "Mod4";
    bars = [];


    keybindings = lib.mkOptionDefault {

      "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
      "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
      "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
      "${modifier}+Shift+b" = "exec systemctl poweroff";
      "${modifier}+backslash" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -n -c 1e272e";

      "${modifier}+Ctrl+Left" = "move workspace to output left";
      "${modifier}+Ctrl+Right" = "move workspace to output right";
      "${modifier}+Ctrl+Up" = "move workspace to output up";
      "${modifier}+Ctrl+Down" = "move workspace to output down";



      "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

      "${modifier}+XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
      "${modifier}+XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";
      "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

      "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl -q s 5%+";
      "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl -q s 5%-";

      "${modifier}+Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot full -c -p \"/home/risson/Pictures/Screenshots\"";
      "Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
      "${modifier}+Shift+s" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";

      "XF86PowerOff" = "exec systemctl suspend-then-hibernate";
    };
		
    startup = [
      {
        command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
        always = true;
        notification = false;
      }
      {
        command = "systemctl --user restart polybar.service";
        always = true;
        notification = false;
      }
      # (let monitorScript = with pkgs; writeScript "monitor.sh" ''
      #     #!${runtimeShell}
      #     SCREEN_LEFT=HDMI-1
      #     SCREEN_RIGHT=eDP-1
      #     START_DELAY=5

      #     renice +19 $$ >/dev/null

      #     sleep $START_DELAY

      #     OLD_DUAL="dummy"

      #     while [ 1 ]; do
      #         DUAL=$(cat /sys/class/drm/card0-HDMI-A-1/status)

      #         if [ "$OLD_DUAL" != "$DUAL" ]; then
      #             if [ "$DUAL" == "connected" ]; then # Dual monitor setup
      #                 xrandr --output $SCREEN_LEFT --auto --above $SCREEN_RIGHT
      #             else # Single monitor setup
      #                 xrandr --auto
      #             fi
      #             systemctl --user restart polybar.service
      #             OLD_DUAL="$DUAL"
      #         fi

      #         # inotifywait -q -e close /sys/class/drm/card0-HDMI-1/status >/dev/null
      #     done
      #   '';
      # in {
      #   command = "${monitorScript}";
      #   always = false;
      #   notification = false;
      # })
    ];
  };
}
