{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/2e9689d0557d1cc5580ae649461454ce3b1c701d") { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "scangearmp2";
  version = "4.11";

  rev = "cbe903e7f8839794fbe572ea4c811e2c802a4038";
  src = pkgs.fetchurl {
    url = "https://github.com/Ordissimo/scangearmp2/archive/v4.11.tar.gz";
    sha256 = "1yfnhjiab14qaaacbmhjd48rwj81wqfx4pld4xhfiv4wz9grp4ny";
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

  NIX_LDFLAGS = "-L/build/scangearmp2-4.11/com/libs_bin64";

  configurePhase = ''
    mkdir -p $out/bin
    cd scangearmp2/
    ./autogen.sh --prefix=$out --bindir=$out/bin/ --enable-libpath=$out/bin/
  '';

  enableParallelBuilding = true;


  installPhase = ''
    cp -R /build/scangearmp2-4.11/com/libs_bin64 $out/lib
    make install
  '';
}
