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
    pcmanfm
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
