{ pkgs, ... }:
{

  virtualisation.oci-containers.containers = {
    pihole = {
      autoStart = true;
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
        ServerIP = "192.168.122.9";
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--hostname=pi.hole"
      ];
      workdir = "/var/lib/pihole/";
    };


    home-assistant = {
      #   image = "homeassistant/raspberrypi4-homeassistant:stable";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      ports = [
        "127.0.0.1:8123:8123"
      ];

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/var/lib/home-assistant/config:/config"
      ];
    };

    bird-lg-proxy = {
      image = "xddxdd/bird-lgproxy-go";
      autoStart = true;
      volumes = [
        "/run/bird.ctl:/var/run/bird/bird.ctl"
      ];
      ports = [
        "172.20.4.98:8000:8000"
      ];
    };
  };
}
