{ ... }:
{
  programs.git = {
    enable = true;

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
      "copilot-instructions.md"
    ];
    lfs.enable = true;
    settings = {
      alias = {
        co = "checkout";
        ci = "commit";
        cp = "cherry-pick";
        st = "status";
        sw = "switch";
      };
      push.autoSetupRemote = true;
      user = {
        name = "David Tchekachev";
        email = "contact" + "@" + "tchekda.fr";
      };
    };
  };
}
