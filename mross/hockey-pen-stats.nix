{ lib, ... }:
{
  imports = [
    ./docker.nix
  ];
  environment.etc = {
    hockey-pen-stats-env = {
      text = builtins.readFile ./hockey-pen-stats.env;
      target = "hockey-pen-stats.env";
      user = "nginx";
      group = "nginx";
    };
  };
  systemd = {
    services.docker-hockey-pen-stats.serviceConfig.Restart = lib.mkForce "on-failure";

    timers.hockey-pen-stats = {
      description = "Trigger a backup of immich folders";

      timerConfig = {
        OnCalendar = "*-*-* *:00:00";
        Persistent = true;
        Unit = "docker-hockey-pen-stats.service";
      };

      wantedBy = [ "timers.target" ];
    };
  };
  virtualisation.oci-containers.containers."hockey-pen-stats" = {
    image = "ghcr.io/tchekda/hockeypenstats:main";
    user = "60:60";
    volumes = [
      "/var/www/hockey-pen-stats/:/app/data"
    ];
    environmentFiles = [ "/etc/hockey-pen-stats.env" ];
  };
}
