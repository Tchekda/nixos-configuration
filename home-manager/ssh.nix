{
  programs.ssh = {
    enable = true;
    extraOptionOverrides = {
      "AddKeysToAgent" = "yes";
    };
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
        serverAliveInterval = 60;
      };
      mross = {
        hostname = "mross.tchekda.fr";
        user = "tchekda";
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
    };
  };
}
