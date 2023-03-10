{ ... }:
{
  sessions = [
    { multi = true; name = "androw_2575"; neigh = "fe80::2575:6%andro_2575_zrh"; as = "4242422575"; link = "4"; }
    { multi = true; name = "bandura_2923"; neigh = "fe80::2923%band_2923_nur"; as = "4242422923"; link = "3"; }
    { multi = true; name = "dgy_0826"; neigh = "fe80::a0e:fb02%dgy_0826_la"; as = "4242420826"; link = "5"; }
    { multi = false; v4 = true; v6 = false; name = "hackfront_1472_v4"; neigh = "172.23.167.1"; as = "4242421472"; link = "4"; }
    { multi = false; v4 = false; v6 = true; name = "hackfront_1472_v6"; neigh = "fe80::1472%hackf_1472_it"; as = "4242421472"; link = "4"; }
    { multi = true; name = "jlu5_1080"; neigh = "fe80::116%jlu5_1080_lon"; as = "4242421080"; link = "3"; }
    { multi = true; name = "kioubit_3914"; neigh = "fe80::ade0%kioubit_3914_uk"; as = "4242423914"; link = "3"; }
    { multi = false; v4 = false; v6 = true; name = "munsternet_2237"; neigh = "fe80::42:2237%munst_2237_lon"; as = "4242422237"; link = "3"; }
    { multi = true; name = "n0emis_0197"; neigh = "fe80::42:42:1%n0emi_0197_gtg"; as = "4242420197"; link = "4"; }
    { multi = true; name = "napsterbater_1050"; neigh = "fe80::1:1050%napst_1050_fra"; as = "4242421050"; link = "2"; }
    { multi = true; name = "niantic_1331"; neigh = "fe80::1331%niant_1331_ams"; as = "4242421331"; link = "3"; }
    #     { multi = true; name = "yuetau_0925"; neigh = "fe80::925%yuetau_0925_nue"; as = "4242420925"; link = "3"; }
  ];
  extraConfig = ''
      protocol bgp iBGP_par_v4 from dnpeers {
            #disabled;
            neighbor 172.20.4.97 as 4242421722;
            ipv4 {
                    next hop self;
                    import all;
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
            #disabled;
            neighbor fd54:fe4b:9ed1:1::1 as 4242421722;
            ipv4 {
                    next hop self;
                    import none;
                    export none;
            };

            ipv6 {
                    next hop self;
                    import all;
                    export where dn42_export_filter(3,25,34);
                    import keep filtered;
            };
    }
  '';
}
