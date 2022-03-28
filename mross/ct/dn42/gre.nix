{ pkgs, lib, ... }:
let
  tunnels = import peers/gre.nix { };
in
{
  networking.localCommands = lib.concatStrings
    (builtins.map
      (x: ''
        ${pkgs.iproute}/bin/ip a show dev ${x.name} || ${pkgs.iproute}/bin/ip -4 tunnel add ${x.name} mode gre remote ${x.remote} local ${x.local}
        ${pkgs.iproute}/bin/ip link set ${x.name} up
        ${pkgs.iproute}/bin/ip -4 a add ${x.address4} peer ${x.peer4} dev ${x.name} || true
        ${pkgs.iproute}/bin/ip -6 a add ${x.address6} peer ${x.peer6} dev ${x.name} || true
      '')
      tunnels.tunnels);
}


