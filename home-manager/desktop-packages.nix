{ pkgs, unstable, ... }:
{
  packages = with pkgs; [
    # Dependencies
    feh
    unstable.flameshot
    libnotify
    # Utils
    alacritty
    gparted
    networkmanagerapplet
    unstable.iwgtk
    brightnessctl
    pavucontrol
    xarchive
    # Applications
    gsettings_desktop_schemas
    lxappearance
    adapta-gtk-theme
    gnome3.adwaita-icon-theme
    pcmanfm
    gnome3.gnome-calculator
    libgnome-keyring
    libreoffice
    hunspell
    hunspellDicts.en-us-large
    hunspellDicts.fr-moderne
    unstable.discord
    bitwarden
    thunderbird
    tdesktop
    signal-desktop
    spotify
    xournal
    wineWowPackages.stable
    unstable.firefox-devedition-bin
    vlc
  ];
}
