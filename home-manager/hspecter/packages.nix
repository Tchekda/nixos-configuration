{ pkgs, unstable, ... }:
let
  curstomPHP8 = pkgs.php80.buildEnv {
    extraConfig =
      ''date.timezone = Europe/Paris
          memory_limit = 1G'';
    extensions = { enabled, all }: enabled ++ [ all.xdebug ];
  };
  m68k = pkgs.qt5.callPackage ./m68k.nix { };

in
{
  packages = with pkgs; [
    # Dev
    openfortivpn
    python39Packages.autopep8
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
    unstable.teams
    unstable.molotov
    kvirc
    zoom-us
    evince
    filezilla
    nixops

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
