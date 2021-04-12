{
  enable = true;
  userName = "David Tchekachev";
  userEmail = "contact" + "@" + "tchekda.fr";
  signing = {
    key = "A4EADA0F";
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
  ];
}
