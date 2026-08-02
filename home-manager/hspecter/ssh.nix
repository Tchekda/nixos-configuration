{ ... }:
{
  programs.ssh = {
    includes = [
      "tsh-config"
      "/home/tchekda/Prog/EPITA/SIGL/UBSI/infra/terraform/environments/staging/ssh_config"
    ];
    settings = {
      deletec = {
        HostName = "192.168.230.10";
        User = "david";
      };
      "git.cri.epita.fr" = {
        HostName = "git.cri.epita.fr";
        User = "david.tchekachev";
      };
      les2vins = {
        HostName = "10.116.116.26";
        User = "les2vins";
      };
      bastion-siops = {
        HostName = "91.243.117.175";
        User = "proxyjump";
        IdentityFile = "~/.ssh/id_epita";
      };
      bitwarden = {
        HostName = "192.168.64.7";
        User = "ubuntu";
        IdentityFile = "~/.ssh/id_epita";
        ProxyJump = "bastion-siops";
      };
      RE_PROD = {
        HostName = "192.168.64.67";
        User = "ubuntu";
        IdentityFile = "~/.ssh/id_epita";
        ProxyJump = "bastion-siops";
      };
      RE_PROD_BDD = {
        HostName = "192.168.64.44";
        User = "ubuntu";
        IdentityFile = "~/.ssh/id_epita";
        ProxyJump = "RE_PROD";
        LocalForward = [
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
        HostName = "192.168.64.13";
        User = "ubuntu";
        ProxyJump = "bastion-siops";
        IdentityFile = "~/.ssh/id_epita";
        LocalForward = [
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
