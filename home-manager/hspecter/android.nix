{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      android-studio
    ];
    sessionPath = [ "$HOME/Android/Sdk/platform-tools" ];
    sessionVariables = {
      ANDROID_HOME = "$HOME/Android/Sdk";
    };
  };
}
