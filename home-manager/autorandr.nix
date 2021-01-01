{ pkgs, ... }:
{
  enable = true;
  profiles = {
    "default" = {
      fingerprint = {
        eDP-1 =
          "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
      };

      config = {
        eDP-1 = {
          enable = true;
          primary = true;
          position = "0x0";
          mode = "1920x1080";
          gamma = "1.0:1.0:1.0";
          rate = "60.03";
        };
      };
    };

    "home" = {
      fingerprint = {
        eDP-1 =
          "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
        HDMI-1 =
          "00ffffffffffff000472f901b67160121a150103a0331d78baee91a3544c99260f5054b30c00714f818095008100d1c0010101010101023a801871382d40582c4500fe1f1100001e000000fd00324c1e5011000a202020202020000000ff005133543038303032343230320a000000fc00416365722045323330480a202001dd02031b71230907078301000067030c001000802143011084e2000f011d007251d01e206e28550081490000001e00000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000000000000000000bf";
      };

      config = {
        eDP-1 = {
          enable = true;
          primary = true;
          position = "0x0";
          mode = "1920x1080";
          gamma = "1.0:1.0:1.0";
          rate = "60.03";
        };
        HDMI-1 = {
          enable = true;
          primary = false;
          position = "0x1080";
          mode = "1920x1080";
          gamma = "1.0:1.0:1.0";
          rate = "60.00";
        };
      };
    };
  };
  hooks = {
    postswitch =
      {
        "move-workspaces-to-main" = ''
          set -euo pipefail

          # Make sure that i3 is running
          if [[ "$( ${pkgs.i3}/bin/i3-msg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true) | .name' | wc -l )" -eq 1 ]]; then
            echo "no other monitor, bailing out"
            exit 0
          fi

          # Figure out the identifier of the main monitor
          readonly main_monitor="$( ${pkgs.i3}/bin/i3-msg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true and .primary == true) | .name' )"

          # Get the list of workspaces that are not on the main monitor
          readonly workspaces=( $(${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.output != "''${main_monitor}") | .name') )

          # Move all workspaces over
          for workspace in "''${workspaces[@]}"; do
            ${pkgs.i3}/bin/i3-msg "workspace ''${workspace}; move workspace to output ''${main_monitor}"
          done
        '';
        "restart-polybar" = ''
          set -euo pipefail

          systemctl --user restart polybar.service
        '';
      };
  };

}
