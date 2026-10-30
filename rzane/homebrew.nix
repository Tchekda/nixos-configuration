{ config, ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none"; # Leave private packages installed
    };

    # caskArgs.no_quarantine = true;
    global.brewfile = true;

    brews = [
      "mint"
      "graphite"
      # Tools also expected by BSP dev-env-setup. Sourcing them from brew
      # (instead of home-manager) lets the BSP script's upgrade checks pass and
      # avoids shadowing brew's copies on PATH.
      "colima"
      "docker"
      "docker-buildx"
      "docker-compose"
      "docker-credential-helper"
      "fzf"
      "gh"
      # "kubectl" # ASDF managed
      "mise"
      "pup"
      # vault not here: hashicorp/tap/vault has no macOS bottle and the
      # source build needs xcode-select pointed at /Library/Developer/CommandLineTools
      # (conflicts with the nix-darwin SDK pin). Installed via home-manager instead.
    ];

    casks = [
      "1password"
      "1password-cli"
      "bitwarden"
      "cursor"
      "dbeaver-community"
      "google-chrome"
      "gcloud-cli"
      "insomnia"
      "session-manager-plugin"
      "slack"
      "spotify"
      "whatsapp"
    ];

    taps = [
      "withgraphite/tap"
      "nikitabobko/tap"
    ];
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = config.system.primaryUser;
    autoMigrate = true;
  };
}
