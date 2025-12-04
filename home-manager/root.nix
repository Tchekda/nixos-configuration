{
  config,
  pkgs,
  lib,
  ...
}:
let
  init-shell-command = pkgs.callPackage ./init-shell-command.nix { };
  my_lnav = if pkgs.system == "x86_64-linux" then [ pkgs.lnav ] else [ ];
in
{
  imports = [
    ./fish.nix
    ./git.nix
    ./vim.nix
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
    sessionPath = [
      "/root/.local/bin"
    ];
    packages =
      with pkgs;
      [
        bat
        dnsutils
        file
        init-shell-command
        inetutils
        iperf3
        jq
        mtr
        neofetch
        python311
        python311Packages.pip
        unrar
        unzip
        zip
      ]
      ++ my_lnav;
    stateVersion = "25.05";
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
