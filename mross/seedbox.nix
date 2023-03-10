{ pkgs, config, lib, ... }:
{
  users.groups.media.members = [ "plex" "radarr" "sonarr" "deluge" "tchekda" "nginx" ];

  networking.firewall = {
    # rTorrent incoming
    allowedTCPPortRanges = [{ from = 40000; to = 59000; }];
    allowedUDPPortRanges = [{ from = 40000; to = 59000; }];
    # DHT
    allowedUDPPorts = [ 6881 ];
  };

  services = {

    plex = {
      enable = true;
      openFirewall = true;
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
        # network.port_random.set = no
        log.add_output = "debug", "log"
        system.umask.set = 000
        schedule2 = scgi_permission,0,0,"execute.nothrow=chmod,777,/run/rtorrent/rpc.sock"
      '';
    };
  };
}

