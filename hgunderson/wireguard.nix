# wg genkey | tee private.key | wg pubkey > public.key
{ config, pkgs, lib, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking = {
    firewall.allowedUDPPorts = [ 51822 ];
    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "vpn" ];
    };
    wireguard = {
      enable = true;
      interfaces.vpn = {
        ips = [ "192.168.5.1/24" "fd42:42:42::1/64" ];
        listenPort = 51822;
        privateKey = builtins.readFile ./server.priv.key;
        allowedIPsAsRoutes = false;
        peers = [
          {
            publicKey = "OpbpDL+E4VOgzGTXga8F3h2aNqlVX6ZKowsWWa83rDA="; # Tablet Dad
            allowedIPs = [ "192.168.5.2/32" "fd42:42:42::2/128" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "qD9y5dFLjx4oTwueEBTLU0a6rP+7hSqa7kgKE7k+xTU="; # Samsung
            allowedIPs = [ "192.168.5.3/32" "fd42:42:42::3/128" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "gxXn4fhEKoZqa0wdYGt6UeU52VisJcfP7vcAfVLIbRk="; # Nixos Thinkpad
            allowedIPs = [ "192.168.5.4/32" "fd42:42:42::4/128" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "1wcqMx9DzIzMFVBgcZz1Tyvxvzy7TsafCMgKm/nuKjg="; # Nast
            allowedIPs = [ "192.168.5.5/32" "fd42:42:42::5/128" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "9zK1uREqqU9lFQQSgLpkj0GxDqU6Q4AzfvMXLDbtABU="; # Tablet Mom
            allowedIPs = [ "192.168.5.6/32" "fd42:42:42::6/128" ];
            persistentKeepalive = 25;
          }
        ];
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -I POSTROUTING -o ens3 -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -t nat -I POSTROUTING -o ens3 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o ens3 -j MASQUERADE
        '';
      };
    };
  };

}


