{ ... }:
{
  programs.ssh.matchBlocks = {
    deletec = {
      hostname = "192.168.230.10";
      user = "david";
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
    lgp = {
      hostname = "lgp.tchekda.fr";
      user = "tchekda";
    };
    russia = {
      hostname = "hgunderson.tchekda.fr";
      user = "root";
    };
    "ssh.cri.epita.fr".extraOptions = {
      GSSAPIAuthentication = "yes";
      GSSAPIDelegateCredentials = "yes";
    };
  };
}
