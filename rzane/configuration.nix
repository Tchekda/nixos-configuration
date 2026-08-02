{
  config,
  pkgs,
  unstable,
  ...
}:

{
  imports = [
    ./homebrew.nix
  ];

  environment.systemPackages = with pkgs; [
    awscli2 # system level for Lens app
  ];

  home-manager = {
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit unstable;
    };
    useUserPackages = true;
    users.dtch = {
      imports = [ ../home-manager/rzane/default.nix ];
      # home.username = lib.mkForce "dtch";
    };
  };

  # nix config
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # disabled due to https://github.com/NixOS/nix/issues/7273
      # auto-optimise-store = true;
    };
    enable = false; # using determinate installer
  };

  programs.fish.enable = true;

  # nix-darwin pins SDKROOT to its bundled Apple SDK, which causes `xcode-select -p`
  # to return a Nix store path instead of /Library/Developer/CommandLineTools.
  # This breaks Homebrew source builds and third-party scripts that rely on the
  # standard CLT location. Reset it on every activation so the system path wins.
  system.activationScripts.fixXcodeSelect.text = ''
    CURRENT=$(xcode-select -p 2>/dev/null || true)
    if [[ "$CURRENT" != "/Library/Developer/CommandLineTools" && "$CURRENT" != */Xcode*.app/* ]]; then
      echo "Resetting xcode-select from $CURRENT to /Library/Developer/CommandLineTools"
      xcode-select --switch /Library/Developer/CommandLineTools
    fi
  '';

  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    defaults = {
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
    };
    primaryUser = "dtch";
    stateVersion = 6;
  };
  users = {
    knownUsers = [ "dtch" ];
    users."dtch" = {
      home = "/Users/dtch";
      shell = pkgs.fish;
      uid = 501;
    };
  };
  environment = {
    systemPath = [
      "/opt/homebrew/bin"
      "/Users/dtch/bin"
    ];
    pathsToLink = [ "/Applications" ];

    # Pin <nixpkgs> system-wide to the nixpkgs this system is built from
    # (pkgs.path = the flake's nixpkgs input), so every `nix-shell` / `import
    # <nixpkgs>` on the machine uses one fixed, already-present, GC-rooted
    # nixpkgs instead of Determinate's mutable nixpkgs-weekly (the
    # extra-nix-path in /etc/nix/nix.conf). That weekly ref is re-fetched from
    # FlakeHub on every tarball-ttl (1h) lapse -- i.e. the first shell each
    # morning -- which is what made shells slow. nix.enable = false here, so
    # nix-darwin's nix.nixPath is inert; nix.custom.conf is Determinate's
    # `!include`-d override file and a nix-path line there wins over
    # extra-nix-path. Tracks the system flake: updates only on
    # `nix flake update` + darwin-rebuild switch.
    etc."nix/nix.custom.conf".text = ''
      nix-path = nixpkgs=${pkgs.path}
    '';
  };

}
