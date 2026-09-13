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

  # nix-darwin 26.05 only executes specific activation-script slots
  # (postActivation / preActivation / extraActivation). Arbitrary-named entries
  # (a former `fixXcodeSelect` / `launchdUserPath`) are defined-but-never-run, so
  # both activation concerns below live under postActivation, which runs as root
  # on every `darwin-rebuild activate`.
  system.activationScripts.postActivation.text = ''
    # (1) nix-darwin pins SDKROOT to its bundled Apple SDK, which makes
    # `xcode-select -p` return a Nix store path and breaks Homebrew source builds
    # / CLT-dependent scripts. Reset it to the standard CLT location.
    CURRENT=$(xcode-select -p 2>/dev/null || true)
    if [[ "$CURRENT" != "/Library/Developer/CommandLineTools" && "$CURRENT" != */Xcode*.app/* ]]; then
      echo "Resetting xcode-select from $CURRENT to /Library/Developer/CommandLineTools"
      xcode-select --switch /Library/Developer/CommandLineTools
    fi

    # (2) GUI apps (Dock/Spotlight-launched, e.g. cmux.app) inherit the launchd
    # session PATH, NOT environment.systemPath below (that only feeds login shells
    # via path_helper). cmux restores agent panes with
    #   login -flp dtch /bin/bash --noprofile --norc -c 'exec -l /bin/sh -c "opencode attach …"'
    # and --noprofile --norc skips every init, so without this the pane gets
    # PATH=/usr/bin:/bin and dies with "opencode: command not found" (opencode is a
    # Homebrew binary at /opt/homebrew/bin). Set the launchd user-domain PATH so
    # GUI apps see ~/.local/bin (secure-enclave-agent shims) and /opt/homebrew/bin. Writes
    # /var/db/com.apple.xpc.launchd/config/user.plist; applies after a reboot.
    /bin/launchctl config user path "/Users/dtch/.local/bin:/opt/homebrew/bin:/Users/dtch/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" || true
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

    # nix-homebrew injects `eval "$(brew shellenv)"` into the generated /etc/zshrc,
    # which PREPENDS /opt/homebrew/bin to PATH in every interactive zsh — ahead of
    # ~/.local/bin (secure-enclave-agent op/gh shims). /etc/zshrc sources /etc/zshrc.local
    # at its end, i.e. after brew shellenv, so re-prepending ~/.local/bin here keeps
    # the shims first in interactive zsh (mirrors fish's fish_add_path in home-manager).
    etc."zshrc.local".text = ''
      # Managed by nix-darwin. Keep ~/.local/bin (secure-enclave-agent shims) ahead of
      # Homebrew after /etc/zshrc's `brew shellenv` reorders PATH.
      export PATH="$HOME/.local/bin:$PATH"
    '';

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
