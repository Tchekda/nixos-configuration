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
      "git.cri.epita.fr" = {
        hostname = "git.cri.epita.fr";
        user = "david.tchekachev";
      };
      les2vins = {
        hostname = "10.116.116.26";
        user = "les2vins";
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
      "ubsi-2026-staging-k3s-master-1" = {
        hostname = "192.168.128.143";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-staging-key";
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
      "ubsi-2026-staging-k3s-worker-1" = {
        hostname = "192.168.128.94";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-staging-key";
      };
      "ubsi-2026-staging-k3s-worker-2" = {
        hostname = "192.168.128.249";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-staging-key";
      };
      "ubsi-2026-staging-k3s-worker-3" = {
        hostname = "192.168.128.189";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-staging-key";
      };
      "ubsi-2026-prod-k3s-master-1" = {
        hostname = "192.168.96.16";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-prod-key";
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
      "ubsi-2026-prod-k3s-worker-1" = {
        hostname = "192.168.96.7";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-prod-key";
      };
      "ubsi-2026-prod-k3s-worker-2" = {
        hostname = "192.168.96.254";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-prod-key";
      };
      "ubsi-2026-prod-k3s-worker-3" = {
        hostname = "192.168.96.170";
        user = "ubuntu";
        proxyJump = "bastion-siops";
        identityFile = "~/.ssh/ubsi-2026-prod-key";
      };
    };
  };
}
