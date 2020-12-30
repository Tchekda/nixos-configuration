{ pkgs, ... }:

{
  enable = true;

  settings = {
    window = {
      title = "Terminal";

      position = {
        x = 900;
        y = 350;
      };
      dimensions = {
        lines = 40;
        columns = 125;
      };
    };

    #font = {
    #  normal.family = "Meslo LG S for Powerline";
    #  size = 10.0;
    #};

    background_opacity = 0.65;

    shell = {
      program = "${pkgs.fish}/bin/fish";
      #args = [ "--init-command" "echo; neofetch; echo" ];
    };
  
  };

}
