{ pkgs, ... }:
{
  systemd.services.init-docker-network = {
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
        check=$(${dockercli} network ls | grep "flaresolverr" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create flaresolverr
        else
          echo "flaresolverr already exists in docker"
        fi
      '';
  };
  virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = [
        "127.0.0.1:8191:8191"
      ];
      environment = {
        LOG_LEVEL = "info";
        CAPTCHA_SOLVER = "hcaptcha-solver";
      };
      extraOptions = [ "--network=flaresolverr" ];
    };

    jackett = {
      image = "ghcr.io/linuxserver/jackett";
      ports = [
        "127.0.0.1:9117:9117"
      ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/dev/null:/downloads"
        "/etc/jackett:/config"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Paris";
        AUTO_UPDATE = "true";
      };
      extraOptions = [ "--network=flaresolverr" ];
    };
  };
}
