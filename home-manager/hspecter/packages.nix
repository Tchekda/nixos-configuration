{
  pkgs,
  config,
  lib,
  unstable,
  nixpkgs25_05,
  ...
}:
let
  # unstable = import <nixos-unstable> {
  #   config = {
  #     allowUnfree = true;
  #   };
  # };
  aurora = pkgs.callPackage ../aurora.nix { };
  # m68k = pkgs.qt5.callPackage ./m68k.nix { };
  # myPostman = pkgs.callPackage ./postman.nix { };
  myLens = pkgs.callPackage ./lens.nix { };
  myMaestralGui = pkgs.maestral-gui.overrideAttrs (old: {
    dontWrapGApps = true;
    nativeBuildInputs = [ pkgs.wrapGAppsHook3 ] ++ old.nativeBuildInputs;
    makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ] ++ old.makeWrapperArgs;
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
    overlays = [
      (final: prev: {
        fritzing = unstable.fritzing;
      })
    ];
  };
  home.packages = with pkgs; [
    aurora.public
    aurora.beta
    aurora.alpha
    # Dev
    awscli2
    # google-cloud-sdk
    # sshuttle
    redli
    python311Packages.autopep8
    python311Packages.virtualenv
    php83Packages.composer
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
    unstable.k9s
    # unstable.code-cursor
    # unstable.claude-code
    # mongodb-compass
    # wkhtmltopdf
    # mailcatcher
    # httpstat
    dbeaver-bin
    # redli # Thanks to me :)
    # arandr
    yubioath-flutter
    # teamviewer
    # mono
    # jetbrains.jdk
    # jetbrains.phpstorm
    # EPITA
    coq_8_20
    coqPackages_8_20.coqide
    fritzing
    # gnumake
    # gcc
    # krb5
    # sshfs
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
    nixpkgs25_05.nixops_unstable_full
    termius
    transmission_4-gtk
    gimp
    myMaestralGui
    telegram-desktop
    signal-desktop
    # Virtualisation
    # virt-manager
    # win-virtio
    # virt-viewer
    # libguestfs-with-appliance
    # usbutils
    amdgpu_top
    # Scanner
    # xsane
    unstable.gscan2pdf
  ];
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
  xdg.systemDirs.data = [
    "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}"
  ];
}
