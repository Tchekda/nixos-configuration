{ pkgs ? import <nixpkgs> { } }:
let
  version = "1.2.3";
  pname = "simtoolkitpro-${version}";
  name = "SimToolkitPro-${version}";

  src = pkgs.fetchurl {
    url = "https://github.com/simtoolkitpro/stkp-client-releases/releases/download/v${version}/SimToolkitPro-${version}-x86_64.Setup.AppImage";
    sha256 = "sha256-3Ru9DG48Pq7jl86QNvhbMMFKHeFaouFvrD6Dm4EKQg0=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit name src; };
in
pkgs.appimageTools.wrapType2 {
  inherit name src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: with pkgs; appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/simtoolkitpro.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with pkgs.lib; {
    description = "SimToolkitPro is a cross-platform Electronic Flight Bag (EFB) for flight simulation";
    homepage = "https://simtoolkitpro.co.uk/";
    license = licenses.mit;
    maintainers = [ maintainers.tchekda ];
  };
}
