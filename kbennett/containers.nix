{ pkgs, config, ... }:
{
  systemd.services.init-flaresolverr-docker-network = {
    description = "Create the network bridge.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script =
      let
        dockercli = "${config.virtualisation.docker.package}/bin/docker";
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
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers.containers = {
      jackett = {
        image = "lscr.io/linuxserver/jackett:latest";
        ports = [
          "127.0.0.1:9117:9117"
        ];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/dev/null:/downloads"
          # Install https://gist.github.com/Clemv95/8bfded23ef23ec78f6678896f42a2b60 in /etc/jackett/cardigans/definitions
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

      flaresolverr = {
        image = "flaresolverr/flaresolverr:latest";
        ports = [
          "127.0.0.1:8191:8191"
        ];
        environment = {
          LOG_LEVEL = "info";
          CAPTCHA_SOLVER = "hcaptcha-solver";
        };
        extraOptions = [ "--network=flaresolverr" ];
      };

      cloudflare-ddns = {
        image = "oznu/cloudflare-ddns";
        environment = {
          API_KEY = builtins.readFile ./cf-apikey;
          ZONE = "tchekda.fr";
          SUBDOMAIN = "lgp";
          RRTYPE = "AAAA";
          CUSTOM_LOOKUP_CMD = "curl -s -6 https://ifconfig.co";
        };
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
