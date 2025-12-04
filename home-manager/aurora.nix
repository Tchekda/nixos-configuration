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
        install -m 444 -D ${appimageContents}/Aurora.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
          --replace-fail 'Name=Aurora' 'Name=Aurora ${channel} (${version})' \
          --replace-fail 'Icon=Aurora' 'Icon=Aurora.png'
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
    sha256 = "sha256-DvUOZfCsS1dV/GZkRIUMH35UkqNeBEc7WOgh46duMvw=";
    version = "1.0.36a";
  };
  beta = generic {
    channel = "beta";
    downloadId = "90";
    sha256 = "sha256-nTLc1SDetAPQogiR1U3iQEuOlWnIyx1YdWqIkyg++6A=";
    version = "1.0.36b";
  };
  public = generic {
    channel = "public";
    downloadId = "98";
    sha256 = "sha256-Vt8WPsipVHFot6ggqUjvKxuPA43V0B6i2uV2TEiQNyY=";
    version = "1.0.36b";
  };
}
