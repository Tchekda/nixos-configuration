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
        hostname = "91.243.117.175";
        user = "proxyjump";
        identityFile = "~/.ssh/id_epita";
      };
      bitwarden = {
        hostname = "192.168.64.7";
        user = "ubuntu";
        identityFile = "~/.ssh/id_epita";
        proxyJump = "bastion-siops";
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
