{ pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  home.packages = with pkgs; [
    # Dependencies
    feh
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
    gsettings-desktop-schemas
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
    discord
    thunderbird
    tdesktop
    signal-desktop
    spotify
    xournal
    firefox-devedition-bin
    vlc
    simplescreenrecorder
  ];
  services.flameshot = {
    enable = true;
    package = unstable.flameshot;
  };
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "inode/directory" = [ "pcmanfm.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "x-scheme-handler/mid" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcal" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcals" = [ "thunderbird.desktop" ];
    };
    defaultApplications = {
      "inode/directory" = [ "pcmanfm.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "message/rfc822" = [ "thunderbird.desktop" ];
      "x-scheme-handler/mid" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcal" = [ "thunderbird.desktop" ];
      "text/calendar" = [ "thunderbird.desktop" ];
      "application/x-extension-ics" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcals" = [ "thunderbird.desktop" ];
      "x-scheme-handler/postman" = [ "Postman.desktop" ];
      "x-scheme-handler/msteams" = [ "teams.desktop" ];
    };
  };
}
