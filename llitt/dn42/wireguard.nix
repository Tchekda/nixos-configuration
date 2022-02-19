{ config, pkgs, lib, ... }:
let
  defaultLocalIPv4 = "172.20.4.98/32";
  defaultLocalIPv6 = "fe80::1722:98/64";
in
{
  environment.systemPackages = [ pkgs.wireguard ];

  networking.wireguard.interfaces = import peers/tunnels.nix rec {
    customTunnel = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: localIPv4: localIPv6: isOspf: {
      listenPort = listenPort;
      privateKey = privateKey;
      allowedIPsAsRoutes = false;
      peers = [
        {
          publicKey = publicKey;
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = endpoint;
          dynamicEndpointRefreshSeconds = 5;
        }
      ];
      postSetup = ''
        ${pkgs.iproute}/bin/ip addr add ${localIPv4} peer ${tunnelIPv4} dev ${name}
        ${pkgs.iproute}/bin/ip -6 addr add ${localIPv6} peer ${tunnelIPv6} dev ${name}
      '' + lib.optionalString isOspf "${pkgs.iproute}/bin/ip -6 addr add ${defaultLocalIPv6} dev ${name}";
    };
    tunnel = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: customTunnel listenPort privateKey publicKey endpoint name tunnelIPv4 tunnelIPv6 defaultLocalIPv4 defaultLocalIPv6 false;
    ospf = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: ULAIPv6: customTunnel listenPort privateKey publicKey endpoint name tunnelIPv4 tunnelIPv6 defaultLocalIPv4 ULAIPv6 true;
  };
}
