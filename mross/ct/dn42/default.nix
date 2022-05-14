{
  imports = [
    ./wireguard.nix
    ./bird2.nix
    ./bind.nix
    ./gre.nix
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.conf.all.rp_filter" = 0;
  };

  networking.interfaces.lo = {
    ipv4.addresses = [{ address = "172.20.4.97"; prefixLength = 32; }];
    ipv6.addresses = [
      { address = "fd54:fe4b:9ed1:1::1"; prefixLength = 128; }
      { address = "fe80::1"; prefixLength = 128; }
    ];
  };
}
