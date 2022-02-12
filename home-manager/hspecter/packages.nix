{ pkgs, unstable, config, ... }:
let
  customPHP8 = pkgs.php80.buildEnv {
    extraConfig =
      ''date.timezone = Europe/Paris
          memory_limit = 1G'';
    extensions = { enabled, all }: enabled ++ [ all.xdebug ];
  };
  m68k = pkgs.qt5.callPackage ./m68k.nix { };
  redli = pkgs.callPackage ./redli.nix { };
  unstable = import ../../unstable.nix { config.allowUnfree = true; };

in
{
  home.packages = with pkgs; [
    # Dev
    openfortivpn
    python39Packages.autopep8
    remmina
    customPHP8
    php80Packages.composer
    nodejs-16_x
    yarn
    docker-compose
    postman
    openssl
    wkhtmltopdf
    mailcatcher
    httpstat
    dbeaver
    mongodb-compass
    redli
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
    slack
    element-desktop
    evince
    filezilla
    unstable.nixopsUnstable
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
