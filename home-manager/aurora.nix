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
          --replace 'Name=Aurora' 'Name=Aurora ${channel} (${version})'
      '' + pkgs.lib.strings.optionalString (channel == "public") ''
        mkdir -p $out/share/icons/hicolor/512x512/apps
        cp -r ${appimageContents}/usr/share/icons $out/share
        cp $out/share/icons/hicolor/0x0/apps/aurora-electron.png $out/share/icons/hicolor/512x512/apps/aurora-electron.png
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
    sha256 = "sha256-4IW/wFhq8gPmLA/x5nbVlTgfcdkBB6ChWQEAusebBUE=";
    version = "1.0.30a";
  };
  beta = generic {
    channel = "beta";
    downloadId = "90";
    sha256 = "sha256-4bV+UWYCGmkTM7ePC/T4y1BiNm84n0LRL7/EfNgWHAc=";
    version = "1.0.30b";
  };
  public = generic {
    channel = "public";
    downloadId = "98";
    sha256 = "sha256-1WOVehe8b8mSaDWpmcGyohxD+UQt/8D1Q0++13MvS7k=";
    version = "1.0.30b";
  };
}
