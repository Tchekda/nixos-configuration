{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    brews = [
      "colima"
      "docker"
      "docker-compose"
      "docker-buildx"
      "docker-credential-helper"
      "gh"
      "git"
      "mise"
    ];

    casks = [
      "1password"
      "1password-cli"
      "bitwarden"
      "cursor"
      "dbeaver-community"
      "google-chrome"
      "slack"
      "spotify"
      "whatsapp"
    ];
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "dtch";
    autoMigrate = true;
  };
}
