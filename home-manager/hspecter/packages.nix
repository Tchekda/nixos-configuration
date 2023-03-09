{ pkgs, unstable, config, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  pdfrankenstein = pkgs.callPackage ./pdfrankenstein.nix { };
  myRedli = pkgs.callPackage ./redli.nix { };
  aurora = pkgs.callPackage ../aurora.nix { };
  myLens = pkgs.callPackage ./lens.nix { };
  m68k = pkgs.qt5.callPackage ./m68k.nix { };
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
    myLens
    unstable.teleport
    postman
    openssl
    # wkhtmltopdf
    mailcatcher
    httpstat
    dbeaver
    # redli # Thanks to me :)
    nethogs
    radeontop
    arandr
    ventoy-bin
    yubioath-desktop
    # mono
    jetbrains.jdk
    jetbrains.webstorm
    jetbrains.phpstorm
    # EPITA
    gnumake
    gcc
    man-pages
    gdb
    tree
    pkg-config
    bear
    clang-tools
    m68k
    # clang
    # Applications
    teams
    kvirc
    zoom-us
    slack
    element-desktop
    filezilla
    unstable.nixops_unstable
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
