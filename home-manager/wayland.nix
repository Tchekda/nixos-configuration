{ config, pkgs, nixosConfig, lib, ... }:
let
  # colorscheme = import ./colors.nix;
  inherit (nixosConfig.networking) hostName;
  theme = "Adwaita";
  wallpaper = builtins.fetchurl {
    url = https://images.pexels.com/photos/1525041/pexels-photo-1525041.jpeg;
    sha256 = "0pl43lrzfxdfgaa9plhlzv8z7ramkrdzmsvdmg03vr9klzqgpx0z";
  };
in
{

  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    font-awesome
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wdisplays
  ];

  programs = {
    mako.enable = true;
  };

  services.swayidle.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    package = null; # don't override system-installed one
    wrapperFeatures.gtk = true; # so that gtk works properly


    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';

    config = {
      left = "n";
      down = "e";
      up = "i";
      right = "o";

      modifier = "Mod4";

      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.wofi}/bin/wofi";

      workspaceAutoBackAndForth = true;
      window = {
        titlebar = true;
        hideEdgeBorders = "both";
      };

      bars = [
        #   {
        #   command = "${pkgs.waybar}/bin/waybar";
        #   position = "bottom";
        #   trayOutput = "*";
        # }
      ];


      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
          # xkb_options = "grp:ctrls_toggle,grp:menu_switch,compose:rctrl-altgr";
          xkb_numlock = "enabled";
        };
        "type:touchpad" = {
          click_method = "clickfinger";
          tap = "enabled";
          accel_profile = "flat";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
        };
      };

      # menu =
      #   "${pkgs.bemenu}/bin/bemenu-run -m all --fn 'Concourse T7' --tf '#${colorscheme.dark.bg_0}' --hf '#${colorscheme.dark.fg_0}' --no-exec | xargs swaymsg exec --";

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          inherit (config.wayland.windowManager.sway.config)
            left down up right menu terminal;
        in
        {
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+q" = "kill";
          "${mod}+d" = "exec ${menu} --show drun";
          "${mod}+Shift+d" = "exec ${menu} --show window";

          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+h" = "split h";
          "${mod}+v" = "split v";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+comma" = "layout stacking";
          "${mod}+period" = "layout tabbed";
          "${mod}+slash" = "layout toggle split";
          "${mod}+a" = "focus parent";
          "${mod}+s" = "focus child";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          "${mod}+Ctrl+Left" = "move workspace to output left";
          "${mod}+Ctrl+Right" = "move workspace to output right";
          "${mod}+Ctrl+Up" = "move workspace to output up";
          "${mod}+Ctrl+Down" = "move workspace to output down";
          "${mod}+Ctrl+Prior" = "exec --no-startup-id ${pkgs.xorg.xrandr}/bin/xrandr --output eDP --rotate inverted";
          "${mod}+Ctrl+Next" = "exec --no-startup-id ${pkgs.xorg.xrandr}/bin/xrandr --output eDP --rotate normal";


          "${mod}+XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
          "${mod}+XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";
          "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          "${mod}+Mod1+Left" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
          "${mod}+Mod1+Right" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
          "${mod}+Mod1+Up" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl pause";
          "${mod}+Mod1+Down" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";

          "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";

          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

          "${mod}+b" = "exec systemctl hibernate";
          "${mod}+Shift+b" = "exec systemctl poweroff";
          "${mod}+Shift+t" = "exec --no-startup-id ${pkgs.autorandr}/bin/autorandr --match-edid -c";
          "XF86Calculator" = "exec --no-startup-id ${pkgs.gnome-calculator}/bin/gnome-calculator";

          "${mod}+Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot full -c -p \"/home/tchekda/Documents/Screenshots\"";
          "Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
          "${mod}+Shift+s" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";

          "${mod}+l" = ''exec ${pkgs.swaylock}/bin/swaylock -i "${wallpaper}"'';
          "${mod}+k" = "exec ${pkgs.mako}/bin/makoctl dismiss";
          "${mod}+Shift+k" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";
          "${mod}+minus" = "scratchpad show";
          "${mod}+underscore" = "move container to scratchpad";
          "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl -q s 5%+";
          "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl -q s 5%-";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+v" = ''mode "system:  [r]eboot  [p]oweroff  [l]ogout"'';
        };

      modes = {
        "system:  [r]eboot  [p]oweroff  [l]ogout" = {
          r = "exec reboot";
          p = "exec poweroff";
          l = "exit";
          Return = "mode default";
          Escape = "mode default";
        };
        resize = {
          Left = "resize shrink width";
          Right = "resize grow width";
          Down = "resize shrink height";
          Up = "resize grow height";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      window.commands = [ ];

      output = { "*".bg = ''"${wallpaper}" fill''; };

      startup = [
        {
          command = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        }
        { command = "${pkgs.mako}/bin/mako"; }
        {
          command =
            let lockCmd = "'${pkgs.swaylock}/bin/swaylock -f -i \"${wallpaper}\"'";
            in
            ''${pkgs.swayidle}/bin/swayidle -w \
              timeout 600 ${lockCmd} \
              timeout 1200 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
              before-sleep ${lockCmd}
        '';
        }
      ];

      assigns = {
        "4" = [
          { class = "Slack"; }
          { app_id = "Element"; }
        ];


        workspaceOutputAssign = [
          # { workspace = "1"; output = "Unknown LCD QHD 1 110503_3"; }
          # { workspace = "2"; output = "Unknown LCD QHD 1 110503_3"; }
          # { workspace = "8"; output = "Goldstar Company Ltd W2363D 0000000000"; }
          # { workspace = "10"; output = "Goldstar Company Ltd W2363D 0000000000"; }
        ];
      };

    };
    extraConfig = "seat seat0 xcursor_theme ${theme}\n";
  };
}
