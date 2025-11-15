{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    aliases = {
      co = "checkout";
      ci = "commit";
      cp = "cherry-pick";
      st = "status";
      sw = "switch";
    };
    userName = "David Tchekachev";
    userEmail = "contact" + "@" + "tchekda.fr";
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
      ".clang-format"
      ".gitconfig"
      "*.code-workspace"
    ];
    extraConfig.push.autoSetupRemote = true;
  };
}
