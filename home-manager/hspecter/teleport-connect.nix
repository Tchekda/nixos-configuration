{ lib, stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "teleport-connect";
  version = "11.0.3";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://cdn.teleport.dev/${pname}-${version}-x64.tar.gz";
    sha256 = "160pnmnmc9zwzyclsci3w1qwlgxkfx1y3x5ck6i587w78570an1r";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  meta = with lib; {
    description = "Teleport Connect provides easy and secure access to SSH servers, databases, and Kubernetes clusters, with support for other resources coming in the future.";
    homepage = "https://goteleport.com/docs/connect-your-client/teleport-connect/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.tchekda ];
  };
}
