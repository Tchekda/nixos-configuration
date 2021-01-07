{ pkgs, config, lib, environment, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/77d190f10931c1d06d87bf6d772bf65346c71777)
    { config = config.nixpkgs.config; };
in
{
  home.packages = with pkgs; [
    openfortivpn
    unstable.php80
    unstable.php80Packages.composer2
    yarn
    docker-compose
    postman
    openssl
    mailcatcher
  ];
}
