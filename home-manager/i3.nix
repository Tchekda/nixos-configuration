{ pkgs, lib, ... }:
let
  wallpaper = builtins.fetchurl {
    url = https://images.pexels.com/photos/1525041/pexels-photo-1525041.jpeg;
    sha256 = "0pl43lrzfxdfgaa9plhlzv8z7ramkrdzmsvdmg03vr9klzqgpx0z";
  };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = rec {
      modifier = "Mod4";
      bars = [ ];


      keybindings = lib.mkOptionDefault {
        "${modifier}+Ctrl+Left" = "move workspace to output left";
        "${modifier}+Ctrl+Right" = "move workspace to output right";
        "${modifier}+Ctrl+Up" = "move workspace to output up";
        "${modifier}+Ctrl+Down" = "move workspace to output down";
        "${modifier}+Ctrl+Prior" = "exec --no-startup-id ${pkgs.xorg.xrandr}/bin/xrandr --output eDP --rotate inverted";
        "${modifier}+Ctrl+Next" = "exec --no-startup-id ${pkgs.xorg.xrandr}/bin/xrandr --output eDP --rotate normal";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";

        "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl -q s 5%+";
        "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl -q s 5%-";

        "${modifier}+XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
        "${modifier}+XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";
        "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        "${modifier}+Mod1+Left" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
        "${modifier}+Mod1+Right" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
        "${modifier}+Mod1+Up" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl pause";
        "${modifier}+Mod1+Down" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";

        "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";

        "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

        "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
        "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${modifier}+b" = "exec systemctl hibernate";
        "${modifier}+Shift+b" = "exec systemctl poweroff";
        "${modifier}+backslash" = "exec --no-startup-id ${pkgs.xautolock}/bin/xautolock -locknow";
        "${modifier}+l" = "exec --no-startup-id ${pkgs.xautolock}/bin/xautolock -locknow";
        "${modifier}+Shift+t" = "exec --no-startup-id ${pkgs.autorandr}/bin/autorandr --match-edid -c";
        "XF86Calculator" = "exec --no-startup-id ${pkgs.gnome3.gnome-calculator}/bin/gnome-calculator";

        "${modifier}+Print" = "exec --no-startup-id ${unstable.flameshot}/bin/flameshot full -c -p \"/home/tchekda/Documents/Screenshots\"";
        "Print" = "exec --no-startup-id ${unstable.flameshot}/bin/flameshot gui";
        "${modifier}+Shift+s" = "exec --no-startup-id ${unstable.flameshot}/bin/flameshot gui";
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
        {
          command = "${pkgs.autorandr}/bin/autorandr --match-edid -c";
          always = false;
          notification = false;
        }
        {
          command = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
          always = true;
          notification = true;
        }
      ];
    };
  };
}
