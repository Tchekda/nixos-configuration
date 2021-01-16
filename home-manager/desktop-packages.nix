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
    brightnessctl
    pavucontrol
    # Applications
    libreoffice
    hunspell
    hunspellDicts.en-us-large
    hunspellDicts.fr-any
    discord
    bitwarden
    thunderbird
    tdesktop
    spotify
    xournal
    firefox-devedition-bin
  ];
}
