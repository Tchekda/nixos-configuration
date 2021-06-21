{ pkgs, unstable, ... }:
{
  packages = with pkgs; [
    # Dependencies
    feh
    flameshot
    libnotify
    # Utils
    alacritty
    gparted
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
    wineWowPackages.stable
    firefox-devedition-bin
    vlc
  ];
}
