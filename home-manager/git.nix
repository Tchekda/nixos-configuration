{
  enable = true;
  userName = "David Tchekachev";
  userEmail = "contact" + "@" + "tchekda.fr";
  signing = {
    key = "D0A007EDA4EADA0F";
    signByDefault = true;
  };
  # extraConfig = {
  #   core = {
  #     autocrlf = true;
  #   };
  # };
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
  ];
}
