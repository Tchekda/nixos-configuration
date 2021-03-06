{
  enable = true;
  extraOptionOverrides = { "AddKeysToAgent" = "yes"; };
  matchBlocks = {
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
    "git.cri.epita.fr" = {
      hostname = "git.cri.epita.fr";
      user = "david.tchekachev";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
  };
}
