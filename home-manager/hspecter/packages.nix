{ pkgs, unstable, config, ... }:
let
  customPHP8 = pkgs.php80.buildEnv {
    extraConfig =
      ''date.timezone = Europe/Paris
          memory_limit = 1G'';
    extensions = { enabled, all }: enabled ++ [ all.xdebug ];
  };
  redli = pkgs.callPackage ./redli.nix { };
  unstable = import ../../unstable.nix { config.allowUnfree = true; };

in
{
  home.packages = with pkgs; [
    # Dev
    python39Packages.autopep8
    python39Packages.virtualenv
    php80Packages.composer
    openfortivpn
    remmina
    customPHP8
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
    # Applications
    teams
    kvirc
    zoom-us
    slack
    element-desktop
    evince
    filezilla
    unstable.nixopsUnstable
    simplescreenrecorder
    termius
    transmission-gtk
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
