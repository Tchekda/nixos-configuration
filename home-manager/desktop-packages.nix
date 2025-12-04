{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Dependencies
    feh
    libnotify
    # Utils
    alacritty
    gparted
    evince
    networkmanagerapplet
    iwgtk
    brightnessctl
    pavucontrol
    pulseaudio
    file-roller
    pciutils
    iw
    wirelesstools
    # Applications
    gsettings-desktop-schemas
    ddcui
    lxappearance
    # adapta-gtk-theme
    adwaita-icon-theme
    gnome-calculator
    gnome-power-manager
    pcmanfm
    libgnome-keyring
    libreoffice
    hunspell
    hunspellDicts.en-us-large
    hunspellDicts.fr-moderne
    discord
    thunderbird-esr
    spotify
    firefox-devedition
    vlc
    simplescreenrecorder
  ];
  services = {
    flameshot = {
      enable = true;
      # package = flameshot;
    };
    gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
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
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/zip" = [ "org.gnome.Nautilus.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "inode/directory" = [ "pcmanfm.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "x-scheme-handler/mid" = [ "thunderbird.desktop" ];
      "x-scheme-handler/postman" = [ "Postman.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/webcal" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcals" = [ "thunderbird.desktop" ];
    };
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/vnd.mozilla.xul+xml" = [ "firefox-devedition.desktop" ];
      "application/x-extension-ics" = [ "thunderbird.desktop" ];
      "application/xhtml+xml" = [ "firefox-devedition.desktop" ];
      "message/rfc822" = [ "thunderbird.desktop" ];
      "inode/directory" = [ "pcmanfm.desktop" ];
      "text/calendar" = [ "thunderbird.desktop" ];
      "text/html" = [ "firefox-devedition.desktop" ];
      "text/xml" = [ "firefox-devedition.desktop" ];
      "x-scheme-handler/https" = [ "firefox-devedition.desktop" ];
      "x-scheme-handler/http" = [ "firefox-devedition.desktop" ];
      "x-scheme-handler/mid" = [ "thunderbird.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "x-scheme-handler/msteams" = [ "teams.desktop" ];
      "x-scheme-handler/postman" = [ "Postman.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/webcal" = [ "thunderbird.desktop" ];
      "x-scheme-handler/webcals" = [ "thunderbird.desktop" ];
    };
  };
}
