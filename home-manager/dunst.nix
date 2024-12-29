{ pkgs, ... }:
let
  soundNotification = pkgs.writeScript "play-notification-sound.sh" ''
    #!/bin/sh
    ${pkgs.pulseaudio}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/window-attention.oga
  '';
in
{
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = "32x32";
    };
    settings = {
      global = {
        geometry = "400x10-30-50";
        frame_color = "#aaaaaa";
        font = "Droid Sans 14";
        sort = "yes";
        markup = "full";
        format = "<b>%a - %s</b>\\n%b";
        idle_threshold = 20;
        line_height = 10;
        padding = 10;
        horizontal_padding = 10;
        separator_height = 10;
        separator_color = "auto";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        mouse_left_click = "do_action";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_current";
      };
      frame = {
        width = 3;
        color = "#aaaaaa";
      };
      urgency_low = {
        background = "#222222";
        foreground = "#888888";
        timeout = 10;
      };
      urgency_normal = {
        background = "#285577";
        foreground = "#ffffff";
        timeout = 10;
      };
      urgency_critical = {
        background = "#900000";
        foreground = "#ffffff";
        frame_color = "#ff0000";
        timeout = 10;
      };

      play_sound = {
        summary = "*";
        script = "${soundNotification}";
      };


    };
  };
}
