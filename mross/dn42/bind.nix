{ pkgs, lib, ... }:

{
  environment.etc = {
    zone-tchekda-dn42 = {
      text = builtins.readFile ./zones/tchekda.dn42;
      target = "zones/tchekda.dn42";
      user = "named";
      group = "named";
    };
    zone-ipv4-reverse = {
      text = builtins.readFile ./zones/ipv4.reverse;
      target = "zones/ipv4.reverse";
      user = "named";
      group = "named";
    };
    zone-ipv6-reverse = {
      text = builtins.readFile ./zones/ipv6.reverse;
      target = "zones/ipv6.reverse";
      user = "named";
      group = "named";
    };
  };
  services.bind = {
    cacheNetworks = [
      "127.0.0.1/32"
      "172.20.0.0/14"
      "fd00::/8"
      "::1/128"
    ];
    enable = true;
    extraOptions = ''
      empty-zones-enable no;
      recursion yes;
      dnssec-validation auto;
      auth-nxdomain no;    # conform to RFC1035
    '';
    extraConfig = ''
      zone "dn42" {
        type forward;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "20.172.in-addr.arpa" {
        type forward;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "21.172.in-addr.arpa" {
        type forward;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "22.172.in-addr.arpa" {
        type forward;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "23.172.in-addr.arpa" {
        type forward;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "10.in-addr.arpa" {
        type forward;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "d.f.ip6.arpa" {
        type forward;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
    '';
    forward = "only";
    listenOn = [
      "!10.199.33.0/24"
      "0.0.0.0/0"
    ];
    zones = {
      "tchekda.dn42" = {
        file = "/etc/zones/tchekda.dn42";
        master = true;
      };
      "96/29.4.20.172.in-addr.arpa" = {
        file = "/etc/zones/ipv4.reverse";
        master = true;
      };
      "1.d.e.9.b.4.e.f.4.5.d.f.ip6.arpa" = {
        file = "/etc/zones/ipv6.reverse";
        master = true;
      };
    };
  };
}
