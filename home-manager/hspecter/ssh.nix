{ ... }:
{
  programs.ssh.matchBlocks = {
    deletec = {
      hostname = "192.168.230.10";
      user = "david";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    vm = {
      hostname = "pve.tchekda.fr";
      user = "root";
      port = 22100;
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    pve = {
      hostname = "pve.tchekda.fr";
      user = "tchekda";
      port = 9137;
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    rpi = {
      hostname = "192.168.2.253";
      user = "pi";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    pi = {
      hostname = "appart.tchekda.fr";
      user = "pi";
      port = 2217;
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    "git.cri.epita.fr" = {
      hostname = "git.cri.epita.fr";
      user = "david.tchekachev";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    delta = {
      hostname = "39damurk.fbxos.fr";
      port = 2217;
      user = "tchekda";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    atr-prod = {
      hostname = "192.168.30.175";
      user = "atr";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    atr-dev = {
      hostname = "192.168.30.174";
      user = "atr";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
    lgp = {
      hostname = "2a01:cb05:8fdb:2555:e490:e2ff:fe7b:497e";
      user = "tchekda";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
  };
}