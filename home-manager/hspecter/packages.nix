{ pkgs, unstable, ... }:
let
  curstomPHP8 = unstable.php80.buildEnv {
    extraConfig =
      ''date.timezone = Europe/Paris
          memory_limit = 1G'';
  };
  m68k = pkgs.qt5.callPackage ./m68k.nix { };

in
{
  packages = with pkgs; [
    # Dev
    openfortivpn
    remmina
    curstomPHP8
    php80Packages.composer
    nodejs-16_x
    yarn
    docker-compose
    postman
    openssl
    wkhtmltopdf
    mailcatcher
    # mono
    unstable.jetbrains.jdk
    jetbrains.phpstorm
    # EPITA
    gnumake
    gcc
    gdb
    m68k
    # Applications
    teams
    unstable.molotov
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
