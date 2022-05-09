{ ... }:
{
  programs.ssh.matchBlocks = {
    deletec = {
      hostname = "192.168.230.10";
      user = "david";
    };
    vm = {
      hostname = "pve.tchekda.fr";
      user = "root";
      port = 22101;
    };
    pve = {
      hostname = "pve.tchekda.fr";
      user = "tchekda";
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
      hostname = "2a01:cb05:8fdb:2555:e490:e2ff:fe7b:497e";
      user = "tchekda";
    };
    russia = {
      hostname = "hgunderson.tchekda.fr";
      user = "root";
    };
    lsh-rnch = {
      hostname = "157.245.140.155";
      user = "root";
    };
    lsh-elk = {
      hostname = "161.35.123.39";
      user = "root";
    };
  };
}
