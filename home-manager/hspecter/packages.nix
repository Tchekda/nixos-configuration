{ pkgs, unstable, config, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  pdfrankenstein = pkgs.callPackage ./pdfrankenstein.nix { };
  myRedli = pkgs.callPackage ./redli.nix { };
  aurora = pkgs.callPackage ../aurora.nix { };
in
{
  home.packages = with pkgs; [
    aurora.public
    aurora.beta
    aurora.alpha
    myRedli
    # Dev
    awscli2
    python39Packages.autopep8
    python39Packages.virtualenv
    php81Packages.composer
    openfortivpn
    remmina
    nixpkgs-fmt
    nodejs-16_x
    yarn
    docker-compose
    kubectl
    lens
    unstable.teleport
    postman
    openssl
    wkhtmltopdf
    mailcatcher
    httpstat
    dbeaver
    # redli # Thanks to me :)
    nethogs
    radeontop
    arandr
    ventoy-bin
    # mono
    jetbrains.jdk
    jetbrains.webstorm
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
    nixopsUnstable
    termius
    transmission-gtk
    gimp
    # pdfrankenstein
    # Virtualisation
    # virt-manager
    # win-virtio
    # virt-viewer
    # libguestfs-with-appliance
    # usbutils
    # Scanner
    xsane
  ];
}
