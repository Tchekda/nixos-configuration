{ buildGo118Module, fetchFromGitHub, lib, pkgs, makeWrapper, gdk-pixbuf, inkscape, poppler_utils, qpdf }:

buildGo118Module rec {
  pname = "pdfrankenstein";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "oxplot";
    repo = pname;
    rev = "f66bcfb8e0970bea032b5be01f4c591055330d7f";
    sha256 = "sha256-63GPul+vvdDfO+IJrCUmoNTyJ3sniJgv3Isg2mMBRpE=";
  };

  vendorSha256 = "sha256-FKB3YiM/zkkW5olfnaCw4AYI7YvcpvLyLSP6xHMd5mY=";

  ldflags = [ "-s" "-w" ];

  buildInputs = with pkgs; [ gtk3 glib ];

  nativeBuildInputs = with pkgs; [ pkg-config makeWrapper ];

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
