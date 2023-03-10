{ config, pkgs, lib, ... }:
{
  boot.kernel.sysctl = {
    # "net.ipv4.ip_forward" = 1; # Already set in dn42 config
    # "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking = {
    firewall.allowedUDPPorts = [ 51822 ];
    wireguard = {
      enable = true;
      interfaces.vpn = {
        ips = [ "192.168.1.1/32" "2001:bc8:2e2a:3::1/64" ];
        listenPort = 51822;
        privateKey = builtins.readFile ./wg-vpn.key;
        allowedIPsAsRoutes = true;
        peers = [
          {
            publicKey = "BtTywlO9DMGh5zb4T/nG6305B12iHGEj7AnVzJIk43g="; # Windows Asus
            allowedIPs = [ "192.168.1.11/32" "2001:bc8:2e2a:3:1::1/80" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "RXypglXW8TOJXxjMxhJ8UAqFzwkXFwkwiQ4v5AYHcUg="; # Samsung
            allowedIPs = [ "192.168.1.12/32" "2001:bc8:2e2a:3:2::1/80" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "gxXn4fhEKoZqa0wdYGt6UeU52VisJcfP7vcAfVLIbRk="; # Nixos Thinkpad
            allowedIPs = [ "192.168.1.13/32" "2001:bc8:2e2a:3:3::1/80" ];
            persistentKeepalive = 25;
          }
        ];
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -I POSTROUTING -o enp0s20f0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o enp0s20f0 -j MASQUERADE
        '';
      };
    };
  };

}


