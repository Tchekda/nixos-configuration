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
    hicolor-icon-theme
    # Utils
    alacritty
    gparted
    evince
    networkmanagerapplet
    iwgtk
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
    # adapta-gtk-theme
    gnome3.adwaita-icon-theme
    pcmanfm
    gnome3.gnome-calculator
    libgnome-keyring
    libreoffice
    hunspell
    hunspellDicts.en-us-large
    hunspellDicts.fr-moderne
    unstable.discord
    thunderbird
    tdesktop
    signal-desktop
    spotify
    xournal
    unstable.firefox-devedition-bin
    vlc
  ];
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "inode/directory" = [ "pcmanfm.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
    defaultApplications = {
      "inode/directory" = [ "pcmanfm.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };
}
