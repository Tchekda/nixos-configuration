{ ... }:
{
  sessions = [
    {
      multi = true; # BGP Multi-Protocol
      name = "session_name";
      neigh = "IPV6_LINK_LOCAL%INTERFACE_NAME";
      as = "424242XXXX";
      link = "LATENCY";
    }
    {
      multi = false;
      v4 = true; # Enable on IPv4 session
      v6 = false;
      name = "session_name_v4";
      neigh = "IPv4 Tunnel IP";
      as = "424242XXXX";
      link = "LATENCY";
    }
  ];
  # Some extra config to configure manually iBGP for example
  extraConfig = ''
      protocol bgp iBGP_par_v4 from dnpeers {
            neighbor 172.20.4.97 as 4242421722;
            ipv4 {
                    next hop self;
                    import where dn42_import_filter(3,25,34);
                    export where dn42_export_filter(3,25,34);
                    import keep filtered;
            };

            ipv6 {
                    next hop self;
                    import none;
                    export none;
            };
      }

      protocol bgp iBGP_par_v6 from dnpeers {
            neighbor fd54:fe4b:9ed1:1::1 as 4242421722;
            ipv4 {
                    next hop self;
                    import none;
                    export none;
            };

            ipv6 {
                    next hop self;
                    import where dn42_import_filter(3,25,34);
                    export where dn42_export_filter(3,25,34);
                    import keep filtered;
            };
    }
  '';
}
