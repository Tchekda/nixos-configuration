{ pkgs, ... }:
let
  unstable = import ../../unstable.nix { config.allowUnfree = true; };
in
{
  nixpkgs.overlays = [
    (self: super: {
      autorandr = unstable.autorandr;
    })
  ];
  programs.autorandr = {
    enable = true;
    profiles = {
      "default" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.01";
          };
        };
      };
      "double" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          HDMI-A-0 =
            "00ffffffffffff0026cd2056a80300000b1c010380301b782a84d5a25a52a2260d5054bf4f00d1c081809500b3008140714f950f0101023a801871382d40582c4500dd0c1100001e000000fd00374c1e5311000a202020202020000000ff0031313137315638333030393336000000fc00504c32323830480a2020202020018002031ff14c010203040510111213141e1f230907018301000065030c0010008c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c110000180000000000000000000000000000000000000000000000000000000000000000000000000000000000004e";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x1080";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.03";
          };
          HDMI-A-0 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.00";
          };
        };
      };
      "double-dock" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          DisplayPort-2 =
            "00ffffffffffff0026cd2056a80300000b1c010380301b782a84d5a25a52a2260d5054bf4f00d1c081809500b3008140714f950f0101023a801871382d40582c4500dd0c1100001e000000fd00374c1e5311000a202020202020000000ff0031313137315638333030393336000000fc00504c32323830480a2020202020018002031ff14c010203040010111213001e1f230907018301000065030c0010008c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c1100001800000000000000000000000000000000000000000000000000000000000000000000000000000000000067";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.03";
          };
          DisplayPort-2 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.00";
          };
        };
      };
      "double-dock-rbt" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          DisplayPort-2 =
            "00ffffffffffff0010acc4a14c5a34331a1f0104a5351e783a5625ab534f9d25105054a54b00714f8180a9c0d1c081c081cf01010101023a801871382d40582c45000f282100001e000000ff00325137324746330a2020202020000000fc0044454c4c205032343232480a20000000fd00384c1e5311010a202020202020005d";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.03";
          };
          DisplayPort-2 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.00";
          };
        };
      };
      "second" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          HDMI-A-0 =
            "00ffffffffffff0026cd2056a80300000b1c010380301b782a84d5a25a52a2260d5054bf4f00d1c081809500b3008140714f950f0101023a801871382d40582c4500dd0c1100001e000000fd00374c1e5311000a202020202020000000ff0031313137315638333030393336000000fc00504c32323830480a2020202020018002031ff14c010203040510111213141e1f230907018301000065030c0010008c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c1";
        };

        config = {
          eDP = {
            enable = false;
            primary = false;
          };
          HDMI-A-0 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.00";
          };
        };
      };
      "second-dock" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          DisplayPort-3 =
            "00ffffffffffff0026cd2056a80300000b1c010380301b782a84d5a25a52a2260d5054bf4f00d1c081809500b3008140714f950f0101023a801871382d40582c4500dd0c1100001e000000fd00374c1e5311000a202020202020000000ff0031313137315638333030393336000000fc00504c32323830480a2020202020018002031ff14c010203040010111213001e1f230907018301000065030c0010008c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c1100001800000000000000000000000000000000000000000000000000000000000000000000000000000000000067";
        };

        config = {
          eDP = {
            enable = false;
            primary = false;
          };
          DisplayPort-3 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.00";
          };
        };
      };
      "duplicate" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          HDMI-A-0 =
            "00ffffffffffff0026cd2056a80300000b1c010380301b782a84d5a25a52a2260d5054bf4f00d1c081809500b3008140714f950f0101023a801871382d40582c4500dd0c1100001e000000fd00374c1e5311000a202020202020000000ff0031313137315638333030393336000000fc00504c32323830480a2020202020018002031ff14c010203040510111213141e1f230907018301000065030c0010008c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c1";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.03";
          };
          HDMI-A-0 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.00";
          };
        };
      };
      "duplicate-dock" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          DisplayPort-3 =
            "00ffffffffffff0026cd2056a80300000b1c010380301b782a84d5a25a52a2260d5054bf4f00d1c081809500b3008140714f950f0101023a801871382d40582c4500dd0c1100001e000000fd00374c1e5311000a202020202020000000ff0031313137315638333030393336000000fc00504c32323830480a2020202020018002031ff14c010203040010111213001e1f230907018301000065030c0010008c0ad08a20e02d10103e9600dd0c11000018011d007251d01e206e285500dd0c1100001e8c0ad090204031200c405500dd0c1100001800000000000000000000000000000000000000000000000000000000000000000000000000000000000067";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.03";
          };
          DisplayPort-3 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.00";
          };
        };
      };
      "rbt-up" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          HDMI-A-0 =
            "00ffffffffffff0034a996a201010101001a0103808048780adaffa3584aa22917494b2008003140614001010101010101010101010104740030f2705a80b0588a00ba882100001e023a801871382d40582c4500ba882100001e000000fc0050616e61736f6e69632d54560a000000fd00173d0f441e000a20202020202001fa020338f053101f05142021220413031207165d5e5f626364230907016e030c001000383c2f088001020304e2004be3051f01e50e61606665662156aa51001e30468f3300ba882100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x2160";
            mode = "1920x1080";
            gamma = "1.0:1.0:1.0";
            rate = "60.03";
          };
          HDMI-A-0 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "3840x2160";
            gamma = "1.0:1.0:1.0";
            rate = "30.00";
            dpi = 192;
          };
        };
      };
      "epita" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          HDMI-A-0 =
            "00ffffffffffff0026cd2f61b6140000101f010380351e782add75a5554e9d270b5054a56b80710081408180a940b3009500950fd1c0023a801871382d40582c45000f282100001e000000ff0031313531313131364335333032000000fd00374c1e5312000a202020202020000000fc00504c32343932480a202020202001ec020322f14f90050403020111121314060715161f230907078301000065030c001000023a801871382d40582c45000f282100001f011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000182a4480a070382740302035000f282100001a00000070";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x1080";
            mode = "1920x1080";
            gamma = "1.0:1.0:1.0";
            rate = "60.03";
          };
          HDMI-A-0 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            gamma = "1.0:1.0:1.0";
            rate = "60.00";
          };
        };
      };
      "501" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d5700000000001c0104a51f1178022285a5544d9a270e505400000001010101010101010101010101010101b43780a070383e401010350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30352e37200a0070";
          HDMI-A-0 =
            "00ffffffffffff000d091bbd000000001e17010380583278ba9d81a3544c99260f5054254f0071408100814081809500950fb300a940641900404100263018883600a05a0000001e023a801871382d40582c4500a05a0000001e000000fd00323c1e440f0200202020202020000000fc0056474120444953504c41590a2001ad02031b71230907078301000067030c001000802143011084e2000f011d007251d01e206e28550081490000001e00000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000010000000000000000000000000000000000000000000000000bf";
        };

        config = {
          eDP = {
            enable = true;
            primary = true;
            position = "0x768";
            mode = "1920x1080";
            gamma = "1.0:1.1:1.2";
            rate = "60.03";
          };
          HDMI-A-0 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1024x768";
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

            # Make sure that i3 is running and only 1 active monitor
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
  };
}
