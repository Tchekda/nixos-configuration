{ pkgs, ... }:
{
  imports = [
    ./wireguard.nix
    ./bird2.nix
    ./bind.nix
    # ./gre.nix # Doesn't work
  ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking = {
    firewall = {
      checkReversePath = false;
    };
    nftables = {
      enable = true;
      ruleset = ''
        table inet dn42filter {
          chain input {
            type filter hook input priority filter; policy accept;
            
            # Accept DN42 traffic
            ip saddr 172.20.0.0/14 accept
            ip6 saddr fd00::/8 accept
            ip6 saddr fe80::/64 accept
          }
        }
      '';
    };
    interfaces.lo = {
      ipv4.addresses = [
        {
          address = "172.20.4.97";
          prefixLength = 32;
        }
      ];
      ipv6.addresses = [
        {
          address = "fd54:fe4b:9ed1:1::1";
          prefixLength = 128;
        }
        {
          address = "fe80::1";
          prefixLength = 128;
        }
      ];
    };
  };
}
