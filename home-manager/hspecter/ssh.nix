{ ... }:
{
  programs.ssh = {
    includes = [
      "tsh-config"
      "/home/tchekda/Prog/EPITA/SIGL/UBSI/infra/terraform/environments/staging/ssh_config"
    ];
    matchBlocks = {
      deletec = {
        hostname = "192.168.230.10";
        user = "david";
      };
      mross = {
        hostname = "mross.tchekda.fr";
        user = "root";
        port = 9137;
      };
      llitt = {
        hostname = "192.168.0.144";
        user = "tchekda";
      };
      rllitt = {
        hostname = "appart.tchekda.fr";
        user = "tchekda";
        port = 2218;
      };
      "git.cri.epita.fr" = {
        hostname = "git.cri.epita.fr";
        user = "david.tchekachev";
      };
      delta = {
        hostname = "swheeler.tchekda.fr";
        port = 2217;
        user = "tchekda";
      };
      lgp = {
        hostname = "lgp.tchekda.fr";
        user = "tchekda";
      };
      lgp-v4 = {
        hostname = "lgp.tchekda.fr";
        user = "tchekda";
        proxyJump = "mross";
      };
      bastion-siops = {
        hostname = "91.243.117.174";
        user = "proxyjump";
        identityFile = "~/.ssh/id_epita";
      };
      RE_PROD = {
        hostname = "192.168.64.67";
        user = "ubuntu";
        identityFile = "~/.ssh/id_epita";
        proxyJump = "bastion-siops";
      };
      RE_PROD_BDD = {
        hostname = "192.168.64.44";
        user = "ubuntu";
        identityFile = "~/.ssh/id_epita";
        proxyJump = "RE_PROD";
        localForwards = [
          {
            host = {
              address = "127.0.0.1";
              port = 3306;
            };
            bind = {
              address = "127.0.0.1";
              port = 3210;
            };
          }
        ];
      };
      "re-narvalo-preprod" = {
        user = "sigl";
        hostname = "192.168.0.179";
        port = 22;
        proxyJump = "epita@re-site-prod";
        identitiesOnly = true;
        localForwards = [
          {
            host = {
              address = "127.0.0.1";
              port = 3306;
            };
            bind = {
              address = "127.0.0.1";
              port = 3210;
            };
          }
        ];
      };
      master-panel = {
        hostname = "192.168.64.13";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/id_epita";
        localForwards = [
          {
            host = {
              address = "127.0.0.1";
              port = 6443;
            };
            bind = {
              address = "127.0.0.1";
              port = 6443;
            };
          }
        ];
      };
    };
  };
}
