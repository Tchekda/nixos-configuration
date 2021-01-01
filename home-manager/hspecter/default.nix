{ pkgs, config, lib, environment, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/eef90463b3478020bdfcefa5c0d718d3380e635d)
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
  ];
}
