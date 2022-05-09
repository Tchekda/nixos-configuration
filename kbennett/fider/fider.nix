{ pkgs, config, ... }:
let
  secrets = import ./secrets.nix;
in
{
  systemd.services.init-fider-docker-network = {
    description = "Create the network bridge.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script =
      let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in
      ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "fider" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create fider
        else
          echo "fider network already exists in docker"
        fi
      '';
  };
  virtualisation.oci-containers.containers = {
    postgres = {
      image = "postgres:12";
      ports = [
        "127.0.0.1:5432:5432"
      ];
      volumes = [
        "//var/fider/pg_data:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_USER = "fider";
        POSTGRES_PASSWORD = secrets.DB_PASS;
      };
      extraOptions = [ "--network=fider" ];
    };

    fider = {
      image = "getfider/fider:stable";
      ports = [
        "127.0.0.1:8002:3000"
      ];
      environment = {
        HOST_DOMAIN = "feedback.tchekda.fr";
        DATABASE_URL = "postgres://fider:${secrets.DB_PASS}@postgres:5432/fider?sslmode=disable";
        JWT_SECRET = secrets.JWT_SECRET;
        EMAIL_NOREPLY = "feedback@tchekda.fr";
        EMAIL_SMTP_HOST = "smtp.tchekda.fr";
        EMAIL_SMTP_PORT = "587";
        EMAIL_SMTP_USERNAME = "admin@tchekda.fr";
        EMAIL_SMTP_PASSWORD = secrets.EMAIL_PASS;
        EMAIL_SMTP_ENABLE_STARTTLS = "true";
      };
      extraOptions = [ "--network=fider" ];
    };
  };
}
