{ pkgs, ... }:

{
    enable = true;

    shellAliases = {
        ls = "ls --color=auto";
        ".." = "cd ..";
        cl = "clear";
        grep="grep --color=auto";
        mkdir="mkdir -pv";
        ports="netstat -tulanp";
        gparted = "sudo gparted";
    };

    shellAbbrs = {
        nrs = "sudo nixos-rebuild -I \"nixos-config=/home/tchekda/nixos-config/hspecter/configuration.nix\" switch";
        ia = "ip a";
        ss = "sudo su";
        ls = "ls -lsah";
        ga = "git add .";
        gc = "git commit -m \"\"";
        gp = "git push";
        gco = "git checkout";
    };

    shellInit = "eval (ssh-agent -c)";

    plugins = [
        {
            name = "theme-lambda";
            src = pkgs.fetchFromGitHub {
              owner = "hasanozgan";
              repo = "theme-lambda";
              rev = "08377e75b860adca35e333b1bc2c30738b17fcba";
              sha256 = "12nwkcm0b9bq1sq470drjd6dq08mi7y5v5wkrhay2kxn9v13mimg";
            };
          }
    ];
}