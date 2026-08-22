{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Slim, self-contained home for the Raspberry Pi: deliberately does NOT
  # import ../home.nix so it skips the heavy desktop/dev tooling (neovim +
  # plugins, python311, nixfmt, ...). Only lightweight shell/CLI bits here.
  imports = [
    ../fish.nix
    ../git.nix
    ../vim.nix
    ../ssh.nix
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
      inetutils
      iperf3
      jq
      mtr
      unzip
      zip
    ];
    stateVersion = "21.05";
  };

  nixpkgs.config.allowUnfree = true;

  news.display = "silent";

  # Trim more weight: no generated HM manual, no XDG mime db on a headless box.
  manual.manpages.enable = false;
  xdg.mime.enable = false;

  programs = {
    home-manager.enable = true;
    command-not-found.enable = lib.mkDefault false;
    man.enable = false;
    htop.enable = true;

    fish = {
      shellAbbrs = {
        nrs = "sudo nixos-rebuild --flake /home/tchekda/nixos-configuration#llitt switch";
      };
    };
  };

  systemd.user.startServices = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 7200;
    enableSshSupport = true;
    enableExtraSocket = true;
    maxCacheTtl = 7200;
    pinentry.package = lib.mkDefault pkgs.pinentry-tty;
  };
}
