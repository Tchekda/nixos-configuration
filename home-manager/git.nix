{ ... }:
{
  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      ci = "commit";
      cp = "cherry-pick";
      st = "status";
      sw = "switch";
    };
    userName = "David Tchekachev";
    userEmail = "contact" + "@" + "tchekda.fr";
    signing = {
      key = "D0A007EDA4EADA0F";
      signByDefault = true;
    };
    ignores = [
      "*.pdf"
      "bin"
      "obj"
      ".idea"
      "*.userprefs"
      "*.DotSettings.user"
      ".direnv"
      "*.d"
      "*.o"
      ".vscode"
      "shell.nix"
      ".envrc"
      ".yalc/"
      "yalc*"
      "*.swp"
      "compile_commands.json"
      ".cache/"
      ".clang_format"
    ];
    extraConfig.push.autoSetupRemote = true;
    includes = [
      {
        path = "~/Prog/IVAO/.gitconfig";
        condition = "gitdir:~/Prog/IVAO/";
      }
      {
        path = "~/Prog/Deloitte/.gitconfig";
        condition = "gitdir:~/Prog/Deloitte/";
      }
      {
        path = "~/Prog/EPITA/.gitconfig";
        condition = "gitdir:~/Prog/EPITA/";
      }
    ];
  };
}
