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
    php80Packages.composer
    vscode
    sass
    compass
    nodejs-16_x
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
    unstable.jetbrains.jdk
    unstable.jetbrains.phpstorm
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
