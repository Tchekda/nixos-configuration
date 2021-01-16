{ pkgs, unstable, ... }:
{
  packages = with pkgs; [
    # Dev
    unstable.php80
    unstable.php80Packages.composer2
    vscode
    yarn
    docker-compose
    postman
    openssl
    mailcatcher
    dotnet-sdk_3
    unstable.jetbrains.jdk
    unstable.jetbrains-mono
    unstable.jetbrains.phpstorm
    unstable.jetbrains.rider
    unstable.jetbrains.pycharm-professional
    # Applications
    teams
    molotov
    pidgin
    openfortivpn
  ];
}
