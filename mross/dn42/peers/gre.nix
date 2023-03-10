{ tunnel }:
let
  defaultLocal = "163.172.50.165";
in
{

  "ashaw_3151_gre" = tunnel "ashaw_3151_gre" "51.89.151.110" defaultLocal "100.64.100.9" "100.64.100.10" 32 "fdc4:b438:8c09:ffff::11" "fdc4:b438:8c09:ffff::12" 64;
  "ashaw_3151_gre2" = tunnel "ashaw_3151_gre2" "198.244.149.164" defaultLocal "100.64.100.14" "100.64.100.13" 30 "fdc4:b438:8c09:ffff::2a" "fdc4:b438:8c09:ffff::29" 126;
  "mc36_1955_eu" = tunnel "mc36_1955_eu" "81.2.241.46" defaultLocal "172.20.4.97" "172.23.215.165" 32 "fd40:cc1e:c0de::112" "fd40:cc1e:c0de::111" 64;
  "gat_0180_gre" = tunnel "gat_0180_gre" "187.189.193.102" defaultLocal "172.20.4.97" "172.22.122.1" 32 "fd42:470:f0ef:304::2" "fd42:470:f0ef:304::1" 64;
}
