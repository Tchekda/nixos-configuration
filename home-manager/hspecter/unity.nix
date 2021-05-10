{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/2e9689d0557d1cc5580ae649461454ce3b1c701d") { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "unity-game";
  version = "1.1";

  rev = "cbe903e7f8839794fbe572ea4c811e2c802a4038";
  src = pkgs.fetchurl {
    url = "https://github.com/sepanou/UnityProject/releases/download/latest/Linux.zip";
    sha256 = "1vcqxgcc5qpr9y4gsinakyjivnsjv31jmf1n5g84b0a6hh49lc3r";
  };

  sourceRoot = ".";

  # nativeBuildInputs = with pkgs; [
  #   autoPatchelfHook
  # ];

  buildInputs = with pkgs; [ unzip ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    ls -lsa
    mkdir -p $out
    cp -r Linux/* $out/
    chmod +x $out/Linux.x86_64
  '';

  preFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $out/ \
      $out/Linux.x86_64
  '';
}
