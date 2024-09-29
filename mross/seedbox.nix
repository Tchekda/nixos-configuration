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
      dataPermissions = "0777";
      downloadDir = "/srv/downloads";
      group = "media";
      configText = ''
        dht.mode.set = auto
        dht.port.set = 6881
        
        log.add_output = "debug", "log"
        
        # network.http.proxy_address.set = socks5h://45.67.230.130:30289
        # network.port_random.set = no
        network.port_range.set = 40000-59000
        
        protocol.encryption.set = allow_incoming,try_outgoing,enable_retry
        protocol.pex.set = 1

        schedule2 = scgi_permission,0,0,"execute.nothrow=chmod,777,/run/rtorrent/rpc.sock"
        
        system.umask.set = 000
        
        trackers.use_udp.set = 1
      '';
    };
  };

  systemd.services = {
    flood = {
      after = [ "network.target" ];
      partOf = [ "rtorrent.service" ];
      wantedBy = [ "network.target" ];
      description = "Flood service";
      serviceConfig = {
        Environment = "HOME=/etc/flood/config";
        Type = "simple";
        User = "rtorrent";
        Group = "media";
        KillMode = "process";
        ExecStart = "${pkgs.flood}/bin/flood --host=\"127.0.0.1\" --baseuri=\"/\" --port=3000 --rtsocket=/run/rtorrent/rpc.sock --allowedpath /srv";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}

