# This doesn't work yet, but it's a start.
{ pkgs, lib, ... }:
let
  # tunnels = import peers/gre.nix { };
in
{
  # networking.localCommands = lib.concatStrings
  #   (builtins.map
  #     (x: ''
  #       ${pkgs.iproute}/bin/ip a show dev ${x.name} || ${pkgs.iproute}/bin/ip -4 tunnel add ${x.name} mode gre remote ${x.remote} local ${x.local}
  #       ${pkgs.iproute}/bin/ip link set ${x.name} up
  #       ${pkgs.iproute}/bin/ip -4 a add ${x.address4} peer ${x.peer4} dev ${x.name} || true
  #       ${pkgs.iproute}/bin/ip -6 a add ${x.address6} peer ${x.peer6} dev ${x.name} || true
  #     '')
  #     tunnels.tunnels);
  networking = {
    interfaces = import peers/gre.nix rec {
      tunnel = name: remote: local: address4: peer4: prefix4: address6: peer6: prefix6: {
        ipv4 = {
          addresses = [
            { address = address4; prefixLength = prefix4; }
          ];
          routes = [
            {
              address = peer4;
              prefixLength = prefix4;
              via = address4;
              type = "multicast";
            }
          ];
        };
        ipv6 = {
          addresses = [
            { address = address6; prefixLength = prefix6; }
          ];
          routes = [
            {
              address = peer6;
              prefixLength = prefix6;
              via = address6;
              type = "multicast";
            }
          ];
        };
        name = name;
        virtual = true;
      };
    };
    greTunnels = import peers/gre.nix rec {
      tunnel = name: remote: local: address4: peer4: prefix4: address6: peer6: prefix6: {
        remote = remote;
        local = local;
        dev = name;
      };
    };
  };
}


