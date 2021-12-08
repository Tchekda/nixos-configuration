{ pkgs, config, lib, ... }:
{
  users.groups.media.members = [ "plex" "radarr" "sonarr" "deluge" "tchekda" ];

  networking.firewall = {
    # Deluge incoming
    allowedTCPPortRanges = [{ from = 40000; to = 59000; }];
    allowedUDPPortRanges = [{ from = 40000; to = 59000; }];
    allowedUDPPorts = [ 6881 ];
  };

  services = {

    plex = {
      enable = true;
      openFirewall = true;
    };

    deluge = {
      enable = false;
      declarative = true;
      openFirewall = true;
      # dataDir = "/srv/library";
      authFile = "/etc/deluge-auth";
      package = pkgs.deluge;
      config = {
        download_location = "/srv/downloads/";
        daemon_port = 58846;
        # listen_ports = [ 40000 59000 ];
        listen_ports = [ 42173 42173 ];
        listen_interface = "eth0";
        random_port = false;
        listen_random_port = 42173;
        max_connections_global = 1000;
      };
      web.enable = true;
    };

    sonarr.enable = true;
    radarr.enable = true;

    rtorrent = {
      enable = true;
      downloadDir = "/srv/downloads";
      group = "media";
      configText = ''
        dht.mode.set = auto
        dht.port.set = 6881
        protocol.pex.set = 1
        trackers.use_udp.set = 1
        network.port_range.set = 40000-59000
        network.port_random.set = yes
        log.add_output = "debug", "log"
        system.umask.set = 0022
      '';
    };
  };
}

