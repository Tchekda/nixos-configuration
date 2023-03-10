{ ... }:
{
  programs.ssh.matchBlocks = {
    deletec = {
      hostname = "192.168.230.10";
      user = "david";
    };
    vm = {
      hostname = "proxmox.tchekda.fr";
      user = "root";
      port = 22101;
    };
    mross = {
      hostname = "mross.tchekda.fr";
      user = "root";
      port = 9137;
    };
    llitt = {
      hostname = "192.168.2.253";
      user = "tchekda";
    };
    rllitt = {
      hostname = "appart.tchekda.fr";
      user = "tchekda";
      port = 2217;
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
    atr-prod = {
      hostname = "192.168.30.175";
      user = "atr";
    };
    atr-dev = {
      hostname = "192.168.30.174";
      user = "atr";
    };
    lgp = {
      hostname = "lgp.tchekda.fr";
      user = "tchekda";
    };
    russia = {
      hostname = "hgunderson.tchekda.fr";
      user = "root";
    };
  };
}
