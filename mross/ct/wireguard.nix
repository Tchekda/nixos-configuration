{ config, pkgs, lib, ... }:
let
  defaultLocalIPv4 = "172.20.4.98/32";
  defaultLocalIPv6 = "fe80::1722:98/64";
in
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  environment.systemPackages = [ pkgs.wireguard ];

  networking = {
    firewall.allowedUDPPorts = [ 51822 ];
    wireguard = {
      enable = true;
      interfaces.vpn = {
        ips = [ "192.168.1.103/24" "2001:bc8:2e2a:103::1/64" ];
        listenPort = 51822;
        privateKey = builtins.readFile ./wg-vpn.key;
        allowedIPsAsRoutes = true;
        peers = [
          {
            publicKey = "BtTywlO9DMGh5zb4T/nG6305B12iHGEj7AnVzJIk43g="; # Windows Asus
            allowedIPs = [ "192.168.1.151/32" "2001:bc8:2e2a:102:1::1/80" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "imVT+ozk92fTMfETryzJG7kwLc58BAseKxWAeGtRNw0="; # OnePlus
            allowedIPs = [ "192.168.1.152/32" "2001:bc8:2e2a:102:2::1/80" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "gxXn4fhEKoZqa0wdYGt6UeU52VisJcfP7vcAfVLIbRk="; # Nixos Thinkpad
            allowedIPs = [ "192.168.1.153/32" "2001:bc8:2e2a:102:3::1/80" ];
            persistentKeepalive = 25;
          }
        ];
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
        '';
      };
    };
  };

}


