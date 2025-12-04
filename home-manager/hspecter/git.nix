{ ... }:
{
  programs.git = {
    settings.safe.directory = "*";
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
      {
        path = "~/Prog/EPITA/SIGL/SiWeb/re-website/.gitconfig";
        condition = "gitdir:~/Prog/EPITA/SIGL/SiWeb/re-website/";
      }
    ];
    signing = {
      key = "D0A007EDA4EADA0F";
      signByDefault = true;
    };
  };
}
