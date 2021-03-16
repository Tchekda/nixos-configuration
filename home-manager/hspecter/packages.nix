{ pkgs, unstable, ... }:
let
  curstomPHP8 = unstable.php80.buildEnv { extraConfig = "date.timezone = Europe/Paris"; };
in
{
  packages = with pkgs; [
    # Dev
    openfortivpn
    curstomPHP8
    unstable.php80Packages.composer2
    vscode
    sass
    unstable.nodejs-15_x
    yarn
    docker-compose
    postman
    openssl
    wkhtmltopdf
    mailcatcher
    dotnet-sdk_3
    mono
    libgdiplus
    graphviz
    imagemagick7
    unstable.jetbrains.jdk
    unstable.jetbrains-mono
    unstable.jetbrains.phpstorm
    unstable.jetbrains.rider
    unstable.jetbrains.pycharm-professional
    unstable.jetbrains.webstorm
    # Applications
    teams
    molotov
    pidgin
    zoom-us
    evince

    # Virtualisation
    virt-manager
    win-virtio
    virt-viewer
    libguestfs-with-appliance

    # Scanner
    xsane
  ];
}
