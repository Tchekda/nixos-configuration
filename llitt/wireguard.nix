{ config, pkgs, ... }:
let
  defaultLocalIPv4 = "172.20.4.98/32";
  defaultLocalIPv6 = "fe80::1722:98/64";
in
{
  # networking.wireguard.interfaces = import peers/tunnels.nix rec {
  #   customTunnel = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: localIPv4: localIPv6: {
  #     listenPort = listenPort;
  #     privateKey = privateKey;
  #     allowedIPsAsRoutes = false;
  #     peers = [
  #       {
  #         publicKey = publicKey;
  #         allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #         endpoint = endpoint;
  #       }
  #     ];
  #     postSetup = ''
  #       ${pkgs.iproute}/bin/ip addr add ${localIPv4} peer ${tunnelIPv4} dev ${name}
  #       ${pkgs.iproute}/bin/ip -6 addr add ${localIPv6} peer ${tunnelIPv6} dev ${name}
  #     '';
  #   };
  #   tunnel = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: customTunnel listenPort privateKey publicKey endpoint name tunnelIPv4 tunnelIPv6 defaultLocalIPv4 defaultLocalIPv6;
  #   ospf = listenPort: privateKey: publicKey: endpoint: name: tunnelIPv4: tunnelIPv6: ULAIPv6: customTunnel listenPort privateKey publicKey endpoint name tunnelIPv4 tunnelIPv6 defaultLocalIPv4 ULAIPv6;
  # };
}
