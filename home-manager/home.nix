{
  config,
  pkgs,
  lib,
  ...
}:
let
  init-shell-command = pkgs.callPackage ./init-shell-command.nix { };
in
{
  imports = [
    ./fish.nix
    ./git.nix
    ./vim.nix
    ./neovim
    ./ssh.nix
  ];

  home = {
    username = lib.mkDefault "tchekda";
    homeDirectory = lib.mkDefault ("/home/" + config.home.username);
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    packages = with pkgs; [
      bat
      dnsutils
      file
      init-shell-command
      (if pkgs.stdenv.isDarwin then pkgs.iproute2mac else pkgs.inetutils)
      iperf3
      jq
      lnav
      mtr
      neofetch
      nixfmt-rfc-style
      python311
      python311Packages.pip
      unrar
      unzip
      zip
    ];
    stateVersion = "21.05";
  };

  nixpkgs = {
    config.allowUnfree = true;
    # overlays = [
    #   (self: super: {
    #     sphinx = drv: drv.overridePythonAttrs (old: { doCheck = false; });
    #   })
    # ];
  };

  news.display = "silent";

  programs = {
    home-manager.enable = true;
    command-not-found.enable = lib.mkDefault true;

    man.enable = false;

    htop.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };

  systemd.user.startServices = true;

  services = {
    gpg-agent = {
      enable = pkgs.stdenv.isLinux;
      defaultCacheTtl = 7200;
      enableSshSupport = true;
      enableExtraSocket = true;
      maxCacheTtl = 7200;
      pinentry.package = lib.mkDefault pkgs.pinentry-tty;
    };
  };

}
