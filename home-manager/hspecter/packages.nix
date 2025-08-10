{
  pkgs,
  config,
  lib,
  ...
}:
let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
  aurora = pkgs.callPackage ../aurora.nix { };
  # m68k = pkgs.qt5.callPackage ./m68k.nix { };
  simtoolkitpro = pkgs.qt5.callPackage ./simtoolkitpro.nix { };
  # myPostman = pkgs.callPackage ./postman.nix { };
  myLens = pkgs.callPackage ./lens.nix { };
  myMaestralGui = pkgs.maestral-gui.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      mkdir -p $out/share/icons/hicolor/512x512/apps
      install -Dm444 src/maestral_qt/resources/maestral.png $out/share/icons/hicolor/512x512/apps
    '';
  });
in
{
  nixpkgs = {
    config = {
      firefox.speechSynthesisSupport = true;

      permittedInsecurePackages = [
        "python-2.7.18.6"
        "nodejs-16.20.2"
        "python3.10-requests-2.28.2"
        "python3.10-cryptography-40.0.1"
      ];
    };
  };
  home.packages = with pkgs; [
    aurora.public
    aurora.beta
    aurora.alpha
    # Dev
    awscli2
    google-cloud-sdk
    sshuttle
    redli
    python311Packages.autopep8
    python311Packages.virtualenv
    php81Packages.composer
    unstable.openfortivpn
    nixfmt-rfc-style
    nodejs_22
    yarn
    pnpm
    cargo
    docker-compose
    kubectl
    kubelogin-oidc
    myLens
    unstable.teleport
    unstable.postman
    openssl
    # mongodb-compass
    # wkhtmltopdf
    # mailcatcher
    httpstat
    dbeaver-bin
    # redli # Thanks to me :)
    arandr
    yubioath-flutter
    # teamviewer
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
    teams-for-linux
    google-chrome
    # kvirc
    zoom-us
    slack
    filezilla
    nixops_unstable_minimal
    termius
    transmission_4-gtk
    gimp
    myMaestralGui
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
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
