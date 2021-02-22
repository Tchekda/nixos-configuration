{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/2e9689d0557d1cc5580ae649461454ce3b1c701d") { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "scangearmp2";
  version = "3.90-1";

  rev = "cbe903e7f8839794fbe572ea4c811e2c802a4038";
  src = pkgs.fetchurl {
    url = "https://gdlp01.c-wss.com/gds/7/0100010487/01/scangearmp2-source-3.90-1.tar.gz";
    sha256 = "10nnh31gkynx8bagygaxxsjxmrakyd35a2mha2d35gqh67z4z8gd";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    cmake
    pkgconfig
    autoconf
    libtool
    glib
    automake
    gtk2-x11
    libusb1
  ];

  NIX_LDFLAGS = "-L/build/scangearmp2-source-3.90-1/com/libs_bin64";

  configurePhase = ''
    cd scangearmp2/
    mkdir build bin
    ./autogen.sh --prefix=/build/scangearmp2-source-3.90-1/scangearmp2/build/ --bindir=/build/scangearmp2-source-3.90-1/scangearmp2/bin/ --sbindir=/build/scangearmp2-source-3.90-1/scangearmp2/bin/ --libexecdir=/build/scangearmp2-source-3.90-1/scangearmp2/bin/ --enable-libpath=/build/scangearmp2-source-3.90-1/scangearmp2/bin/
  '';


  installPhase = ''
    mkdir -p $out
    cp -R /build/scangearmp2-source-3.90-1/com/libs_bin64 $out/lib
    make install
    cp -R build/share $out/
    cd bin/
    install -m755 -D scangearmp2 $out/bin/scangearmp2
  '';
}
