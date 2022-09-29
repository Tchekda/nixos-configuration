{ pkgs ? import <nixpkgs> { } }:
let
  pname = "aurora-electron";
  version = "0.1.23a";
  name = "Aurora.Alpha-${version}";

  src = pkgs.fetchurl {
    # url = "https://api.ivao.aero/v2/softwares/aurora/90/files/latest/download";
    url = "https://api.ivao.aero/v2/softwares/aurora/70/files/latest/download";
    sha256 = "sha256-bOeP2TbFCHBTkxtqfmlbNnUmlZlgvcEe4kCfFlvupZM=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit name src; };
in
pkgs.appimageTools.wrapType2 {
  inherit name src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: with pkgs; appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ icu libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  profile = ''
    export LC_ALL=fr_FR.UTF-8
  '';

  meta = with pkgs.lib; {
    description = "Unofficial Aurora for Linux desktop client";
    homepage = "https://ivao.aero";
    license = licenses.mit;
    maintainers = [ maintainers.tchekda ];
  };
}
