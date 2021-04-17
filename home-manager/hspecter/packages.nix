{ pkgs, unstable, ... }:
let
  curstomPHP8 = unstable.php80.buildEnv {
    extraConfig =
      ''date.timezone = Europe/Paris
          memory_limit = 1G'';
  };
in
{
  packages = with pkgs; [
    # Dev
    openfortivpn
    curstomPHP8
    unstable.php80Packages.composer
    vscode
    sass
    compass
    unstable.nodejs-15_x
    yarn
    docker-compose
    postman
    openssl
    wkhtmltopdf
    mailcatcher
    dotnet-sdk_3
    heroku
    mono
    libgdiplus
    graphviz
    imagemagick7
    jetbrains.jdk
    jetbrains-mono
    jetbrains.phpstorm
    jetbrains.rider
    jetbrains.pycharm-professional
    jetbrains.webstorm
    # Applications
    teams
    molotov
    kvirc
    zoom-us
    evince
    filezilla

    # Virtualisation
    virt-manager
    win-virtio
    virt-viewer
    libguestfs-with-appliance
    usbutils

    # Scanner
    xsane
  ];
}
