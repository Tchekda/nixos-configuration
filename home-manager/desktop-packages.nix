{ pkgs, unstable, ... }:
let
  unstable = import ../unstable.nix { config.allowUnfree = true; };
in
{
  home.packages = with pkgs; [
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
    pulseaudio
    xarchive
    pciutils
    iw
    wirelesstools
    # Applications
    gsettings_desktop_schemas
    ddcui
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
    discord
    thunderbird
    tdesktop
    signal-desktop
    spotify
    xournal
    firefox-devedition-bin
    vlc
  ];
}
