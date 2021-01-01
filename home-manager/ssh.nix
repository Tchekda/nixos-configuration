{
  enable = true;
  extraOptionOverrides = { "AddKeysToAgent" = "yes"; };
  matchBlocks = {
    deletec = {
      hostname = "192.168.230.10";
      user = "david";
      identityFile = "/home/tchekda/.ssh/id_rsa";
    };
  };
}
