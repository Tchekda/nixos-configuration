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
    ];
  };
}
