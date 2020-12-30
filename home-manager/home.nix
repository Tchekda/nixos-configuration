{ config, pkgs, lib, ... }:

{
  imports = [
    ./local.nix 
  ];

  nixpkgs.config.allowUnfree = true;
  

  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    alacritty = import ./alacritty.nix { inherit pkgs; };

    git = {
      enable = true;
      userName = "David Tchekachev";
      userEmail = "contact" + "@" + "tchekda.fr";
      signing = {
       key = "A4EADA0F";
       signByDefault = true;
      };
    };
  };

  services = {
    gpg-agent = {
      enable = false;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    polybar = import ./polybar.nix { inherit pkgs; };

  }; 

  home = {
    username = "tchekda";
    homeDirectory = "/home/tchekda";
    packages = with pkgs; [
      feh brightnessctl flameshot
      htop neofetch zip unzip alacritty unrar gparted lnav pavucontrol
      vscode docker-compose
      discord teams bitwarden
    ];
  };

  xsession.windowManager.i3 = import ./i3.nix { inherit pkgs lib; };
}
