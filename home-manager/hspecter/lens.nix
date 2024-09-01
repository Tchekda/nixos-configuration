{ lib, fetchurl, appimageTools, wrapGAppsHook, makeWrapper }:

let
  pname = "lens";
  version = "6.10.38";
  build = "2024.7.161041-latest";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${build}.x86_64.AppImage";
    sha256 = "sha256-cYqxDiUfGc6KAGk5Xw+Ifl8bemB8X38Kyy18oQj5BHg=";
    name = "${pname}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands =
    ''
      mv $out/bin/${name} $out/bin/${pname}
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      install -m 444 -D ${appimageContents}/lens-desktop.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/lens-desktop.png \
         $out/share/icons/hicolor/512x512/apps/${pname}.png
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Icon=lens-desktop' 'Icon=${pname}' \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks RossComputerGuy ];
    platforms = [ "x86_64-linux" ];
  };
}
