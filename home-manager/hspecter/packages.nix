{ pkgs, unstable, config, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  home.packages = with pkgs; [
    # Dev
    python39Packages.autopep8
    python39Packages.virtualenv
    php80Packages.composer
    openfortivpn
    remmina
    nodejs-16_x
    yarn
    docker-compose
    postman
    openssl
    wkhtmltopdf
    mailcatcher
    httpstat
    dbeaver
    mongodb-compass
    unstable.redli # Thanks to me :)
    # mono
    unstable.jetbrains.jdk
    jetbrains.phpstorm
    # EPITA
    gnumake
    gcc
    gdb
    # Applications
    teams
    kvirc
    zoom-us
    slack
    element-desktop
    filezilla
    unstable.nixopsUnstable
    simplescreenrecorder
    termius
    transmission-gtk
    # Virtualisation
    virt-manager
    win-virtio
    virt-viewer
    libguestfs-with-appliance
    usbutils
    # Scanner
    xsane
  ];
}
