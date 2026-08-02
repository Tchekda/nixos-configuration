{
  pkgs ? import <nixpkgs> { },
}:
let
  generic =
    {
      channel,
      downloadId,
      sha256,
      version,
    }:
    let
      pname = "aurora-electron-${channel}";

      src = pkgs.fetchurl {
        inherit sha256;
        url = "https://download.ivao.aero/v2/softwares/aurora/${downloadId}/files/latest/download";
      };

      appimageContents = pkgs.appimageTools.extract { inherit pname src version; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname src version;

      multiPkgs = null; # no 32bit needed
      extraPkgs =
        pkgs:
        with pkgs;
        appimageTools.defaultFhsEnvArgs.multiPkgs pkgs
        ++ [
          icu
          libsecret
          libinput
        ];

      extraInstallCommands = ''
        # ls -la ${appimageContents}
        install -m 444 -D ${appimageContents}/aurora-electron.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
          --replace-fail 'Name=Aurora' 'Name=Aurora ${channel} (${version})'
      ''
      + pkgs.lib.strings.optionalString (channel == "public") ''
        mkdir -p $out/share/icons/hicolor/1024x1024/apps
        cp -r ${appimageContents}/usr/share/icons $out/share
        # cp $out/share/icons/hicolor/0x0/apps/Aurora.png $out/share/icons/hicolor/1024x1024/apps/Aurora.png
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
    sha256 = "sha256-UhykWRv1PDRHMgyHm1J615b9nyWyLaUg2v/W3zwZtqg=";
    version = "1.0.36a";
  };
  beta = generic {
    channel = "beta";
    downloadId = "90";
    sha256 = "sha256-waWmWNmSG+di6Yot4iKgI++yRU/f8ZjyDOASoE2aPDw=";
    version = "1.0.36b";
  };
  public = generic {
    channel = "public";
    downloadId = "98";
    sha256 = "sha256-2tgXv2C/T/98nmDT1pKScLXI+xB7VXVbql+gvoSk4fU=";
    version = "1.0.36b";
  };
}
