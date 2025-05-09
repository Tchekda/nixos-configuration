{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 6;
          y = 6;
        };
        opacity = 0.90;
      };

      font = {
        # normal = {
        #   family = "JetBrains Mono";
        #   style = "Regular";
        # };
        size = 8.5;
      };

      terminal.shell = "${pkgs.fish}/bin/fish";

      colors = {
        primary = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        cursor = {
          text = "0x44475a";
          cursor = "0xf8f8f2";
        };
        selection = {
          text = "0xf8f8f2";
          background = "0x44475a";
        };
        normal = {
          black = "0x000000";
          red = "0xff5555";
          green = "0x50fa7b";
          yellow = "0xf1fa8c";
          blue = "0xbd93f9";
          magenta = "0xff79c6";
          cyan = "0x8be9fd";
          white = "0xbfbfbf";
        };
        bright = {
          black = "0x4d4d4d";
          red = "0xff6e67";
          green = "0x5af78e";
          yellow = "0xf4f99d";
          blue = "0xcaa9fa";
          magenta = "0xff92d0";
          cyan = "0x9aedfe";
          white = "0xe6e6e6";
        };
        dim = {
          black = "0x14151b";
          red = "0xff2222";
          green = "0x1ef956";
          yellow = "0xebf85b";
          blue = "0x4d5b86";
          magenta = "0xff46b0";
          cyan = "0x59dffc";
          white = "0xe6e6d1";
        };
      };
    };
  };
}
