{ pkgs ? import <nixpkgs> { } }:
let
  generic = { channel, downloadId, sha256, version }:
    let
      pname = "aurora-electron-${channel}";
      name = "Aurora.${channel}-${version}";

      src = pkgs.fetchurl {
        inherit sha256;
        url = "https://download.ivao.aero/v2/softwares/aurora/${downloadId}/files/latest/download";
      };

      appimageContents = pkgs.appimageTools.extract { inherit name src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit name src;

      multiPkgs = null; # no 32bit needed
      extraPkgs = pkgs: with pkgs; appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ icu libsecret ];

      extraInstallCommands = ''
        mv $out/bin/${name} $out/bin/${pname}

        install -m 444 -D ${appimageContents}/aurora-electron.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}' \
          --replace 'Name=Aurora' 'Name=Aurora ${version} (${channel})'
      '' + pkgs.lib.strings.optionalString (channel == "public") ''
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
    };
in
{
  alpha = generic {
    channel = "alpha";
    downloadId = "70";
    sha256 = "sha256-+xKNeQONRGi8bnd8O8qgWQRY34j2p4yAJY9rmAhqETs=";
    version = "1.0.27a";
  };
  beta = generic {
    channel = "beta";
    downloadId = "90";
    sha256 = "sha256-RGJ5/+fBj8tqpF/sH8fOUNurqMBpWg7eDN/ayyndkc0=";
    version = "1.0.28b";
  };
  public = generic {
    channel = "public";
    downloadId = "98";
    sha256 = "sha256-sIzbnOt3mnn3sxCK/E1Lv4ovmsNmbieZN9yd/pqPk/Y=";
    version = "1.0.28b";
  };
}
