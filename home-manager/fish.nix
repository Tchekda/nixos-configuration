{ pkgs, ... }:
{
  enable = true;

  shellAliases = {
    ls = "ls --color=auto";
    ".." = "cd ..";
    cl = "clear";
    grep = "grep --color=auto";
    mkdir = "mkdir -pv";
    ports = "netstat -tulanp";
    gparted = "sudo gparted";
  };

  shellAbbrs = {
    nrs = "sudo nixos-rebuild -I \"nixos-config=/home/tchekda/nixos-config/hspecter/configuration.nix\" switch";
    vpn = "sudo openfortivpn -c /home/tchekda/nixos-config/home-manager/hspecter/vpn-config";
    ia = "ip a";
    s = "sudo";
    ss = "sudo su";
    ls = "ls -lsah";
    gs = "git status";
    ga = "git add .";
    gc = "git commit -a -m \"\"";
    gp = "git push";
    gco = "git checkout";
    speedtest = "iperf3 -t 0 -c bouygues.testdebit.info -p 9201";
  };

  plugins = [
    {
      name = "theme-lambda";
      src = pkgs.fetchFromGitHub {
        owner = "tchekda";
        repo = "theme-lambda";
        rev = "1d599f05dc560d7c9fa0660fa72e2d32251f6f65";
        sha256 = "1s0pyc7nlxlynszlskmzrg57rq2nszbkzjq714hl1g5g19gxp95k";
      };
    }
    {
      name = "fish-ssh-agent";
      src = pkgs.fetchFromGitHub {
        owner = "danhper";
        repo = "fish-ssh-agent";
        rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
        sha256 = "1fvl23y9lylj4nz6k7yfja6v9jlsg8jffs2m5mq0ql4ja5vi5pkv";
      };
    }
  ];

  functions = { "fish_greeting" = builtins.readFile ./fish_greeting.fish; };
}
