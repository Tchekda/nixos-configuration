{ buildGo118Module, fetchFromGitHub, lib, pkg-config, makeWrapper, gdk-pixbuf, inkscape, poppler_utils, qpdf, gtk3, glib }:

buildGo118Module rec {
  pname = "pdfrankenstein";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "oxplot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1O9eLnOYyY6GgOU6qmstT7ul+h/uIBvRWlzRX6ev5Cc=";
  };

  vendorSha256 = "sha256-2l22begx1xdCxQLns2jYsDc+F8BrMWIYfFU4Fbp+cO0=";

  ldflags = [ "-s" "-w" ];

  buildInputs = [ gtk3 glib ];

  nativeBuildInputs = [ pkg-config makeWrapper ];

  postInstall = ''
    install -Dm644 LICENSE "$out/share/licenses/${pname}/LICENSE"
    install -Dm0644 ${pname}.desktop -t "$out/share/applications/"
    install -Dm0644 icon.svg "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
  '';

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --set PATH ${lib.makeBinPath [
        gdk-pixbuf
        inkscape
        poppler_utils
        qpdf
      ]}
  '';


  meta = with lib; {
    description = "GUI tool that intends to fill the gap on Linux where a good capable PDF annotator like Adobe Acrobat does not exist.";
    homepage = "https://github.com/oxplot/pdfrankenstein";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tchekda ];
  };
}
