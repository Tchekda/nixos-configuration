{ config, ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "none"; # Leave private packages installed
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    # brews = [
    # ];

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

    # taps = [
    # ];
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = config.system.primaryUser;
    autoMigrate = true;
  };
}
