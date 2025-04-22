{
  lib,
  fetchurl,
  appimageTools,
  wrapGAppsHook,
  makeWrapper,
}:

let
  pname = "lens";
  version = "2025.4.92142";
  channel = "latest";
  # channel = "beta";
  build = "${version}-${channel}";
  name = "${pname}-${build}";

  src = fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${build}.x86_64.AppImage";
    # url = "https://downloads.k8slens.dev/ide/Lens-${build}.x86_64.AppImage";
    sha256 = "sha256-Qlihuykw/HjQFBENYY/r1EJgfN3m9Dfz4BRBddVO5gQ=";
    name = "${pname}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
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
    maintainers = with maintainers; [
      dbirks
      RossComputerGuy
    ];
    platforms = [ "x86_64-linux" ];
  };
}
