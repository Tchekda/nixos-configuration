{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.kernel.sysctl = {
    # "net.ipv4.ip_forward" = 1; # Already set in dn42 config
    # "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking = {
    firewall.allowedUDPPorts = [ 51822 ];
    nftables = {
      enable = true;
      ruleset = ''
        table inet wireguard {
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            
            # Masquerade VPN traffic going out
            oifname "enp0s20f0" masquerade
          }
          
          chain forward {
            type filter hook forward priority filter; policy accept;
            
            # Accept VPN forwarding
            iifname "vpn" accept
            oifname "vpn" accept
          }
        }
      '';
    };
    wireguard = {
      enable = true;
      interfaces.vpn = {
        ips = [
          "192.168.1.1/32"
          "2001:bc8:2e2a:3::1/64"
        ];
        listenPort = 51822;
        privateKey = builtins.readFile ./wg-vpn.key;
        allowedIPsAsRoutes = true;
        peers = [
          {
            publicKey = "BtTywlO9DMGh5zb4T/nG6305B12iHGEj7AnVzJIk43g="; # Windows Asus
            allowedIPs = [
              "192.168.1.11/32"
              "2001:bc8:2e2a:3:1::1/80"
            ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "RXypglXW8TOJXxjMxhJ8UAqFzwkXFwkwiQ4v5AYHcUg="; # Samsung
            allowedIPs = [
              "192.168.1.12/32"
              "2001:bc8:2e2a:3:2::1/80"
            ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "gxXn4fhEKoZqa0wdYGt6UeU52VisJcfP7vcAfVLIbRk="; # Nixos Thinkpad
            allowedIPs = [
              "192.168.1.13/32"
              "2001:bc8:2e2a:3:3::1/80"
            ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "pN5HOzguLrG9YTEEYrI1D3Qm8tcXwn541lNTtahdLik="; # Mami
            allowedIPs = [
              "192.168.1.14/32"
              "2001:bc8:2e2a:3:4::1/80"
            ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "cbmzzMFmkjCMJKtFeozFeKIizaLbt+fe8/Qa7vpjuxc="; # Papi
            allowedIPs = [
              "192.168.1.15/32"
              "2001:bc8:2e2a:3:5::1/80"
            ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

}
