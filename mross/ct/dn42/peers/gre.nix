{}:
let
  defaultLocal = "192.168.1.102";
in
{
  tunnels = [
    {
      name = "ashaw_3151_gre";
      remote = "51.89.151.110";
      local = defaultLocal;
      address4 = "100.64.100.9";
      peer4 = "100.64.100.10";
      address6 = "fdc4:b438:8c09:ffff::11";
      peer6 = "fdc4:b438:8c09:ffff::12";
    }
    {
      name = "ashaw_3151_gre2";
      remote = "198.244.149.164";
      local = defaultLocal;
      address4 = "100.64.100.14/30";
      peer4 = "100.64.100.13";
      address6 = "fdc4:b438:8c09:ffff::2a/126";
      peer6 = "fdc4:b438:8c09:ffff::29/126";
    }
    {
      name = "mc36_1955_eu";
      remote = "81.2.241.46";
      local = defaultLocal;
      address4 = "172.20.4.97/32";
      peer4 = "172.23.215.165";
      address6 = "fd40:cc1e:c0de::112/64";
      peer6 = "fd40:cc1e:c0de::111/64";
    }
    {
      name = "gat_0180_gre";
      remote = "187.189.193.102";
      local = defaultLocal;
      address4 = "172.20.4.97/32";
      peer4 = "172.22.122.1";
      address6 = "fd42:470:f0ef:304::2";
      peer6 = "fd42:470:f0ef:304::1/64";
    }
  ];
}
