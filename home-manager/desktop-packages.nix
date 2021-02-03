{ pkgs, unstable, ... }:
{
  packages = with pkgs; [
    # Dependencies
    feh
    flameshot
    # Utils
    alacritty
    gparted
    wpa_supplicant_gui
    networkmanagerapplet
    brightnessctl
    pavucontrol
    # Applications
    papirus-icon-theme
    pcmanfm
    gnome3.gnome-calculator
    libreoffice
    hunspell
    hunspellDicts.en-us-large
    hunspellDicts.fr-moderne
    discord
    bitwarden
    thunderbird
    tdesktop
    signal-desktop
    spotify
    xournal
    firefox-devedition-bin
  ];
}
