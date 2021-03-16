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
    xarchive
    # Applications
    gsettings_desktop_schemas
    lxappearance
    papirus-icon-theme
    pcmanfm
    gnome3.gnome-calculator
    libgnome-keyring
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
