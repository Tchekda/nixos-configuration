{
  lib,
  fetchurl,
  appimageTools,
  wrapGAppsHook,
  makeWrapper,
}:

let
  pname = "lens-desktop";
  version = "2025.6.261308";
  channel = "latest";
  # channel = "beta";
  build = "${version}-${channel}";

  src = fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${build}.x86_64.AppImage";
    # url = "https://downloads.k8slens.dev/ide/Lens-${build}.x86_64.AppImage";
    sha256 = "sha256-R7gRqdbJ9rOTjZ7Tdy0OX7RtXpMAc+6YbcZY11h8h2E=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname src version;
  };

in
appimageTools.wrapType2 {
  inherit pname src version;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
       $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  extraPkgs = pkgs: [ pkgs.nss_latest ];

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.lens;
    maintainers = with maintainers; [
      dbirks
      RossComputerGuy
    ];
    platforms = [ "x86_64-linux" ];
  };
}
