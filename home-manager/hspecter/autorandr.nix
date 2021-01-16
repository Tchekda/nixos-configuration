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
          "00ffffffffffff0026cd2056a80300000b1c010380301b782a84d5a25a52a2260d5054bf4f00d1c081809500b3008140714f950f0101023a801871382d40582c4500dd0c1100001e000000fd00374c1e5311000a202020202020000000ff0031313137315638333030393336000000fc00504c32323830480a2020202020018002031ff14c010203040510111213141e1f230907018301000065030c0010008c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c110000180000000000000000000000000000000000000000000000000000000000000000000000000000000000004e";
      };

      config = {
        eDP-1 = {
          enable = true;
          primary = true;
          position = "0x1080";
          mode = "1920x1080";
          gamma = "1.0:1.0:1.0";
          rate = "60.03";
        };
        HDMI-1 = {
          enable = true;
          primary = false;
          position = "0x0";
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
            # Figure out the identifier of the main monitor
            readonly main_monitor="$( ${pkgs.i3}/bin/i3-msg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true and .primary == true) | .name' )"

            # Get the list of workspaces that are not on the main monitor
            readonly workspaces=( $(${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.output != "''${main_monitor}") | .name') )

            # Move all workspaces over
            for workspace in "''${workspaces[@]}"; do
              ${pkgs.i3}/bin/i3-msg "workspace ''${workspace}; move workspace to output ''${main_monitor}"
            done
          fi
        '';
        "restart-polybar" = ''
          set -euo pipefail

          systemctl --user restart polybar.service
        '';
      };
  };

}
