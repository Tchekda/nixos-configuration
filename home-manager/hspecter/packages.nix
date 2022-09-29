{ pkgs, unstable, config, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  pdfrankenstein = pkgs.callPackage ./pdfrankenstein.nix { };
  aurora = pkgs.callPackage ./aurora.nix { };
  myRedli = pkgs.callPackage ./redli.nix { };
in
{
  home.packages = with pkgs; [
    aurora
    myRedli
    # Dev
    awscli2
    python39Packages.autopep8
    python39Packages.virtualenv
    php80Packages.composer
    openfortivpn
    remmina
    nixpkgs-fmt
    nodejs-16_x
    yarn
    docker-compose
    kubectl
    lens
    teleport
    postman
    openssl
    wkhtmltopdf
    mailcatcher
    httpstat
    dbeaver
    teleport
    # redli # Thanks to me :)
    nethogs
    radeontop
    arandr
    ventoy-bin
    # mono
    jetbrains.jdk
    jetbrains.phpstorm
    jetbrains.webstorm
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
    nixopsUnstable
    simplescreenrecorder
    termius
    transmission-gtk
    gimp
    pdfrankenstein
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
