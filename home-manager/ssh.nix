{
  programs.ssh = {
    enable = true;
    extraOptionOverrides = {
      "AddKeysToAgent" = "yes";
    };
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = true;
        ServerAliveInterval = 60;
      };
      mross = {
        HostName = "mross.tchekda.fr";
        User = "tchekda";
        Port = 9137;
      };
      llitt = {
        HostName = "192.168.0.144";
        User = "tchekda";
      };
      rllitt = {
        HostName = "appart.tchekda.fr";
        User = "tchekda";
        Port = 2218;
      };
      delta = {
        HostName = "swheeler.tchekda.fr";
        Port = 2217;
        User = "tchekda";
      };
      lgp = {
        HostName = "lgp.tchekda.fr";
        User = "tchekda";
      };
      lgp-v4 = {
        HostName = "lgp.tchekda.fr";
        User = "tchekda";
        ProxyJump = "mross";
      };
    };
  };
}
