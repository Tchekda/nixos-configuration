{ pkgs, unstable, config, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  nixos-23_05 = import <nixos-23.05> {
    config = {
      permittedInsecurePackages = [
        "teams-1.5.00.23861"
      ];
    };
  };
  pdfrankenstein = pkgs.callPackage ./pdfrankenstein.nix { };
  aurora = pkgs.callPackage ../aurora.nix { };
  myLens = pkgs.callPackage ./lens.nix { };
  # m68k = pkgs.qt5.callPackage ./m68k.nix { };
  simtoolkitpro = pkgs.qt5.callPackage ./simtoolkitpro.nix { };
in
{
  nixpkgs.config = {
    firefox.speechSynthesisSupport = true;
    permittedInsecurePackages = [
      "python-2.7.18.6"
      "nodejs-16.20.2"
      "python3.10-requests-2.28.2"
      "python3.10-cryptography-40.0.1"
    ];
  };
  home.packages = with pkgs; [
    aurora.public
    aurora.beta
    aurora.alpha
    # Dev
    awscli2
    redli
    python39Packages.autopep8
    python39Packages.virtualenv
    php81Packages.composer
    unstable.openfortivpn
    remmina
    nixpkgs-fmt
    nodejs-18_x
    corepack
    cargo
    docker-compose
    kubectl
    myLens
    # unstable.lens
    unstable.teleport
    nixos-23_05.postman
    openssl
    simtoolkitpro
    # mongodb-compass
    # wkhtmltopdf
    # mailcatcher
    httpstat
    dbeaver
    # redli # Thanks to me :)
    arandr
    ventoy-bin
    yubioath-flutter
    teamviewer
    # mono
    jetbrains.jdk
    jetbrains.phpstorm
    # EPITA
    gnumake
    gcc
    krb5
    sshfs
    # criterion.dev
    # criterion
    # gcovr
    # man-pages
    # gdb
    tree
    ripgrep
    pkg-config
    # bear
    # clang-tools
    # patchelf
    stdenv.cc
    # m68k
    # clang
    # Applications
    nixos-23_05.teams
    google-chrome
    # kvirc
    zoom-us
    slack
    filezilla
    nixops_unstable
    termius
    transmission-gtk
    gimp
    maestral-gui
    # pdfrankenstein
    # Virtualisation
    # virt-manager
    # win-virtio
    # virt-viewer
    # libguestfs-with-appliance
    # usbutils
    amdgpu_top
    # Scanner
    xsane
    gscan2pdf
  ];
}
