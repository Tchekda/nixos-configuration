{ config, pkgs, lib, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1; # Already set in dn42 config
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  environment.systemPackages = [ pkgs.wireguard ];

  networking = {
    firewall.allowedUDPPorts = [ 51822 ];
    wireguard = {
      enable = true;
      interfaces.vpn = {
        ips = [ "192.168.5.1/24" "fd42:42:42::1/64" ];
        listenPort = 51822;
        privateKey = builtins.readFile ./server.priv.key;
        allowedIPsAsRoutes = false;
        peers = [
          {
            publicKey = "OpbpDL+E4VOgzGTXga8F3h2aNqlVX6ZKowsWWa83rDA="; # Tablet
            allowedIPs = [ "192.168.5.2/32" "fd42:42:42::2/128" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "ZaT3qiDAPiVEwvIiN9/oIYqmArD5lb2MAXdIvOyi4Eo="; # OnePlus
            allowedIPs = [ "192.168.5.3/32" "fd42:42:42::3/128" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "gxXn4fhEKoZqa0wdYGt6UeU52VisJcfP7vcAfVLIbRk="; # Nixos Thinkpad
            allowedIPs = [ "192.168.5.4/32" "fd42:42:42::4/128" ];
            persistentKeepalive = 25;
          }
        ];
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
        '';
      };
    };
  };

}


