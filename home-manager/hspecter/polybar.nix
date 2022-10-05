{ pkgs, ... }:
let
  bg = "#272727";
  fg = "#CACACA";
  ac = "#1E88E5";
  mf = "#383838";
in
{
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      pulseSupport = true;
    };

    script = ''
      for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
        MONITOR=$m polybar -q -r main &
      done
    '';

    config = {
      "global/wm" = {
        margin-bottom = 0;
        margin-top = 0;
      };

      "bar/main" = {
        monitor = "$\{env:MONITOR:eDP}";
        monitor-strict = false;
        override-redirect = false;

        bottom = true;
        fixed-center = true;

        width = "100%";
        height = 25;

        offset-x = "0%";
        offset-y = "0%";

        background = bg;
        foreground = fg;

        radius-top = "0.0";
        radius-bottom = "0.0";

        overline-size = 3;
        underline-size = 3;
        overline-color = bg;
        underline-color = bg;

        border-top-size = 4;
        border-color = ac;

        padding = 0;

        module-margin-left = 1;
        module-margin-right = 0;

        font-0 = "Termsyn:size=11;2";

        modules-left = "i3";
        modules-center = "";
        # modules-right = "cpu memory temperature pulseaudio microphone battery backlight wireless-network wired-network date";
        modules-right = "cpu temperature pulseaudio battery backlight wireless-network direct-wired-network date";

        spacing = 0;

        dim-value = "1.";

        tray-position = "right";
        tray-background = bg;
        tray-padding = 3;

        enable-ipc = true;
      };

      "settings" = {
        throttle-output = 5;
        throttle-output-for = 10;
        throttle-input-for = 30;

        screenchange-reload = true;

        compositing-background = "source";
        compositing-foreground = "over";
        compositing-overline = "over";
        comppositing-underline = "over";
        compositing-border = "over";

        pseudo-transparency = "false";
      };

      "module/i3" = {
        type = "internal/i3";

        index-sort = true;

        format = "<label-state> <label-mode>";

        label-mode = "%mode%";
        label-mode-padding = 1;
        label-mode-background = "#e60053";

        label-unfocused-padding = 1;
        label-focused = "%index%";
        label-focused-foreground = "#ffffff";
        label-focused-background = "#3f3f3f";
        label-focused-underline = ac;
        label-focused-padding = 1;
        label-visible = "%index%";
        label-visible-underline = "#555555";
        label-visible-padding = 1;

        label-urgent = "%index%";
        label-urgent-foreground = "#000000";
        label-urgent-background = bg;
        label-urgent-padding = 1;
      };

      "module/cpu" = {
        type = "internal/cpu";

        interval = "0.5";

        format = "<label>";
        format-background = mf;
        format-underline = bg;
        format-overline = bg;
        format-padding = 1;

        label = "CPU %percentage%%";
      };

      "module/memory" = {
        type = "internal/memory";

        interval = 3;

        format = "<label>";
        format-background = mf;
        format-underline = bg;
        format-overline = bg;
        format-padding = 1;

        label = "RAM %percentage_used%%";
      };

      "module/temperature" = {
        type = "internal/temperature";

        interval = "0.5";

        thermal-zone = 0;
        warn-temperature = 85;
        units = true;

        hwmon-path = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon2/temp1_input";

        format = "<label>";
        format-background = mf;
        format-underline = bg;
        format-overline = bg;
        format-padding = 1;

        format-warn = "<label-warn>";
        format-warn-background = mf;
        format-warn-underline = bg;
        format-warn-overline = bg;
        format-warn-padding = 1;

        label = "TEMP %temperature-c%";
        label-warn = "TEMP %temperature-c%";
        label-warn-foreground = "#f00";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format-volume = "VOL <label-volume>";
        format-volume-background = mf;
        format-volume-underline = bg;
        format-volume-overline = bg;
        format-volume-padding = 1;

        label-volume = "%percentage%%";

        format-muted-background = mf;
        format-muted-underline = bg;
        format-muted-overline = bg;
        format-muted-padding = 1;

        label-muted = "VOL MUTED";
        label-muted-foreground = ac;
      };

      "module/microphone" = (
        let micScript = with pkgs; writeScript "mic-status.sh" ''
          #!${runtimeShell}
          set -eEuo pipefail

          readonly default_source="$(${pulseaudio}/bin/pactl info | ${gawk}/bin/awk '/Default Source/ {print $3}')"
          readonly is_muted="$(${pulseaudio}/bin/pactl list | ${gnugrep}/bin/grep -E  "Name: $default_source$|Mute:" | ${gnugrep}/bin/grep "Name:" -A1 | ${gawk}/bin/awk '/Mute:/ {print $2}')"
          readonly volume="$(${pulseaudio}/bin/pactl list | ${gnugrep}/bin/grep -E "Name: $default_source$|Volume" | ${gnugrep}/bin/grep "Name:" -A1 | ${coreutils}/bin/tail -1 | ${coreutils}/bin/cut -d% -f1 | ${coreutils}/bin/cut -d/ -f2 | ${coreutils}/bin/tr -d " ")"

          if [[ "$is_muted" == "yes" ]]; then
            echo "MUTED"
          elif [[ "$volume" -lt 33 ]]; then
            echo "$volume%"
          elif [[ "$volume" -ge 33 ]] && [[ "$volume" -lt 66 ]]; then
            echo "$volume%"
          elif [[ "$volume" -ge 66 ]]; then
            echo "$volume%"
          fi
        '';
        in
        {
          type = "custom/script";
          interval = 3;
          exec = "${micScript}";
          format = "MIC <label>";
          format-background = mf;
          format-underline = bg;
          format-overline = bg;
          format-padding = 1;
        }

      );

      "module/battery" = {
        type = "internal/battery";

        full-at = 89;
        low-at = 15;

        battery = "BAT0"; # TODO: Better way to fill this
        adapter = "ADP1";

        poll-interval = 2;

        time-format = "%H:%M";

        format-charging = "CHR <label-charging>";
        format-charging-background = mf;
        format-charging-underline = bg;
        format-charging-overline = bg;
        format-charging-padding = 1;
        format-discharging = "BAT <label-discharging>";
        format-discharging-background = mf;
        format-discharging-underline = bg;
        format-discharging-overline = bg;
        format-discharging-padding = 1;

        label-charging = "%percentage%% (%time%)";
        label-discharging = "%percentage%% (%time%)";
        label-full = "FULL CHR";
        label-full-foreground = "#0f0";
        label-full-background = mf;
        label-full-underline = bg;
        label-full-overline = bg;
        label-full-padding = 1;
        format-low = "<label-low>";
        label-low = "CRIT %percentage%% (%time%)";
        label-low-foreground = "#f00";
        label-low-background = mf;
        label-low-underline = bg;
        label-low-overline = bg;
        label-low-padding = 1;
      };

      "module/backlight" = {
        type = "internal/backlight";
        card = "amdgpu_bl0";
        enable-scroll = true;
        format = "LGT <label>";
        format-background = mf;
        format-underline = bg;
        format-overline = bg;
        format-padding = 1;

        label = "%percentage%%";
      };

      "module/direct-wired-network" = {
        type = "internal/network";
        interface = "enp5s0";

        interval = "1.0";

        accumulate-stats = false;
        unknown-as-up = true;

        format-connected = "<label-connected>";
        format-connected-background = mf;
        format-connected-underline = bg;
        format-connected-overline = bg;
        format-connected-padding = 1;
        label-connected = "LAN : D %downspeed:2% | U %upspeed:2%";
      };

      "module/dock-wired-network" = {
        type = "internal/network";
        interface = "enp7s0f3u1u1";

        interval = "1.0";

        accumulate-stats = false;
        unknown-as-up = true;

        format-connected = "<label-connected>";
        format-connected-background = mf;
        format-connected-underline = bg;
        format-connected-overline = bg;
        format-connected-padding = 1;
        label-connected = "Dock : D %downspeed:2% | U %upspeed:2%";
      };

      "module/wireless-network" = {
        type = "internal/network";
        interface = "wlan0";
        interval = "1.0";
        accumulate-stats = true;
        unknown-as-up = true;
        format-connected = "<label-connected>";
        format-connected-background = mf;
        format-connected-underline = bg;
        format-connected-overline = bg;
        format-connected-padding = 1;
        label-connected = "%essid% : D %downspeed:2% | U %upspeed:2%";
      };


      "module/date" = {
        type = "internal/date";

        interval = "1.0";

        date = "%d-%m-%y";
        date-alt = "%A, %d %B %Y";
        time = "%H:%M";
        time-alt = "%H:%M:%S";

        format = "<label>";
        format-padding = 1;
        format-foreground = fg;

        label = "%date% %time%";
      };

    };
  };
}
