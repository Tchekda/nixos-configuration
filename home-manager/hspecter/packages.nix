{ pkgs, unstable, config, lib, ... }:
let
  unstable = import <nixos-unstable> {
    config = { allowUnfree = true; };
    overlays = [
      (final: prev: {
        postman = prev.postman.overrideAttrs (old: rec {
          postFixup = ''
            pushd $out/share/postman
            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" postman
            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" chrome_crashpad_handler
            for file in $(find . -type f \( -name \*.node -o -name postman -o -name \*.so\* \) ); do
              ORIGIN=$(patchelf --print-rpath $file); \
              patchelf --set-rpath "${lib.makeLibraryPath old.buildInputs}:$ORIGIN" $file
            done
            popd
            wrapProgram $out/bin/postman --set PATH ${lib.makeBinPath [ unstable.openssl pkgs.xdg-utils unstable.toybox]}
          '';
        });
      })
    ];
  };
  nixos-23_05 = import <nixos-23.05> {
    config = {
      permittedInsecurePackages = [
        "teams-1.5.00.23861"
      ];
    };
    # overlays = [
    #   (final: prev: {
    #     postman = prev.postman.override (old: rec {
    #       # force glib to be 2.68.4
    #       # buildInputs = old.buildInputs ++ [ pkgs.glib ];
    #       # glib = pkgs.glib;
    #       # stdenv = pkgs.stdenv;
    #       nativeBuildInputs = [ pkgs.wrapGAppsHook prev.copyDesktopItems ];
    #     });
    #   })
    # ];
  };
  pdfrankenstein = pkgs.callPackage ./pdfrankenstein.nix { };
  aurora = pkgs.callPackage ../aurora.nix { };
  myLens = pkgs.callPackage ./lens.nix { };
  # m68k = pkgs.qt5.callPackage ./m68k.nix { };
  simtoolkitpro = pkgs.qt5.callPackage ./simtoolkitpro.nix { };
  myPostman = pkgs.callPackage ./postman.nix { };
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
    # overlays = [
    #   (final: prev: {
    #     postman = prev.postman.overrideAttrs (old: rec {
    #       # version = "10.12.0";
    #       # src = final.fetchurl {
    #       #   url = "https://dl.pstmn.io/download/version/${version}/linux64";
    #       #   sha256 = "sha256-QaIj+SOQGR6teUIdLB3D5klRlYrna1MoE3c6UXYEoB4=";
    #       #   name = "${old.pname}-${version}.tar.gz";
    #       # };
    #       # buildInputs = old.buildInputs ++ [ unstable.xdg-utils unstable.toybox ];
    #       # postFixup = ''
    #       #   pushd $out/share/postman
    #       #   patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" postman
    #       #   patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" chrome_crashpad_handler
    #       #   for file in $(find . -type f \( -name \*.node -o -name postman -o -name \*.so\* \) ); do
    #       #     ORIGIN=$(patchelf --print-rpath $file); \
    #       #     patchelf --set-rpath "${lib.makeLibraryPath old.buildInputs}:$ORIGIN" $file
    #       #   done
    #       #   popd
    #       #   wrapProgram $out/bin/postman --set PATH ${lib.makeBinPath [ unstable.openssl pkgs.xdg-utils unstable.toybox]}
    #       # '';
    #     });
    #   })
    # ];
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
    myPostman
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
    nixos-23_05.teams
    google-chrome
    # kvirc
    zoom-us
    slack
    filezilla
    nixopsUnstable
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
