{ pkgs, ... }:
{

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
      workdir = "/var/lib/pihole/";
    };

    jackett = {
      image = "jackett_data:/config ghcr.io/linuxserver/jackett";
      ports = [
        "127.0.0.1:9117:9117"
      ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/dev/null:/downloads"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Paris";
        AUTO_UPDATE = "true";
      };
      workdir = "/var/lib/pihole/";
    };
  };
}
