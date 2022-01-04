{ pkgs, config, ... }:
{
  systemd.services.init-docker-network = {
    description = "Create the network interface.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script =
      let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in
      ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "local_net" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create local_net
        else
          echo "local_net already exists in docker"
        fi
      '';
  };
  virtualisation.oci-containers.containers = {
    "pi.hole" = {
      image = "pihole/pihole:latest";
      volumes = [
        "/var/lib/pihole/:/etc/pihole/"
        "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
      ];
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "127.0.0.1:3080:80"
      ];
      environment = {
        TZ = "Europe/Paris";
        PIHOLE_DNS_ = "2606:4700:4700::1111;1.1.1.1;1.0.0.1;2606:4700:4700::1001";
        DNSSEC = "true";
        DNS_BOGUS_PRIV = "false";
        ServerIP = "192.168.2.253";
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--hostname=pi.hole"
        "--network=local_net"
      ];
      workdir = "/var/lib/pihole/";
    };


    home-assistant = {
      #   image = "homeassistant/raspberrypi4-homeassistant:stable";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      ports = [
        "8123:8123"
      ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/var/lib/home-assistant/config:/config"
      ];
      extraOptions = [
        "--network=local_net"
        "--add-host=host.docker.internal:host-gateway"
      ];
    };

    # https://github.com/xddxdd/bird-lg-go#build-docker-images
    bird-lg-proxy = {
      image = "local/bird-lgproxy-go";
      volumes = [
        "/run/bird.ctl:/var/run/bird/bird.ctl"
      ];
      ports = [
        "172.20.4.98:8000:8000"
      ];
      extraOptions = [
        "--network=local_net"
      ];
    };
  };
}
