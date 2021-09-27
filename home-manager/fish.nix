{ pkgs, ... }:
{
  enable = true;

  shellAliases = {
    ls = "ls --color=auto";
    ".." = "cd ..";
    cl = "clear";
    grep = "grep --color=auto";
    mkdir = "mkdir -pv";
  };

  shellAbbrs = {
    nrs = "sudo nixos-rebuild -I \"nixos-config=/home/tchekda/nixos-configuration/hspecter/configuration.nix\" switch";
    hms = "home-manager -f /home/tchekda/nixos-configuration/home-manager/home.nix switch";
    vpn = "sudo openfortivpn -c /home/tchekda/nixos-configuration/home-manager/hspecter/vpn-config";
    ia = "ip a";
    s = "sudo";
    ss = "sudo su";
    ls = "ls -lsah";
    gs = "git status";
    ga = "git add .";
    gc = "git commit -a -m \"\"";
    gp = "git push";
    gco = "git checkout";
    gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    speedtest = "iperf3 -t 0 -c bouygues.testdebit.info -p 9201";
  };

  plugins = [
    {
      name = "theme-lambda";
      src = pkgs.fetchFromGitHub {
        owner = "hasanozgan";
        repo = "theme-lambda";
        rev = "9cf5825c31a1d09d37d87e681ac2fa1d771ef6d2";
        sha256 = "1aq8r27n4ifickg7my039k618d7dllknyi4g7x742hcy19zr1336";
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
