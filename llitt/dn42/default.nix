{ pkgs, ... }: {
  imports = [
    ./wireguard.nix
    ./bird2.nix
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
      extraCommands = ''
        ${pkgs.iptables}/bin/iptables -A INPUT -s 172.20.0.0/14 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -A INPUT -s fd00::/8 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -A INPUT -s fe80::/64 -j ACCEPT
      '';
    };
    interfaces.lo = {
      ipv4.addresses = [{ address = "172.20.4.98"; prefixLength = 32; }];
      ipv6.addresses = [
        { address = "fd54:fe4b:9ed1:2::1"; prefixLength = 128; }
        { address = "fe80::1"; prefixLength = 128; }
      ];
    };
  };
}
