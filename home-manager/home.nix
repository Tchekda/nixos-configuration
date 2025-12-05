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
    ./neovim/default.nix
  ];

  home = {
    username = "tchekda";
    homeDirectory = "/home/tchekda";
    sessionPath = [
      "/home/tchekda/.local/bin"
    ];
    packages = with pkgs; [
      bat
      dnsutils
      file
      init-shell-command
      inetutils
      iperf3
      jq
      lnav
      mtr
      neofetch
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
    command-not-found.enable = true;

    man.enable = false;

    htop.enable = true;

    ssh = {
      enable = true;
      extraOptionOverrides = {
        "AddKeysToAgent" = "yes";
      };
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = true;
        serverAliveInterval = 60;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };

  systemd.user.startServices = true;

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 7200;
      enableSshSupport = true;
      enableExtraSocket = true;
      maxCacheTtl = 7200;
      pinentry.package = lib.mkDefault pkgs.pinentry-tty;
    };
  };

}
