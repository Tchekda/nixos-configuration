{ lib, stdenv, direnv }:

stdenv.mkDerivation {
  name = "init-shell";

  phases = [ "installPhase" "fixupPhase" ];

  preferLocalBuild = true;

  src = ./.;

  installPhase = ''
    install -Dm755 $src/init-nix-shell.sh $out/bin/init-nix-shell
    substituteInPlace $out/bin/init-nix-shell \
      --subst-var-by direnv_bin ${direnv}/bin/direnv
  '';

  meta = with lib; {
    platforms = platforms.linux;
  };
}
