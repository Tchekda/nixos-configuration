{
  pkgs,
  config,
  lib,
  ...
}:
let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  users.groups.media.members = [
    "plex"
    "radarr"
    "sonarr"
    "deluge"
    "tchekda"
    "nginx"
  ];

  networking.firewall = {
    # rTorrent incoming
    allowedTCPPortRanges = [
      {
        from = 40000;
        to = 59000;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 40000;
        to = 59000;
      }
    ];
    # DHT
    allowedUDPPorts = [ 6881 ];
  };

  services = {
    plex = {
      enable = true;
      openFirewall = true;
      package = unstable.plex;
    };

    sonarr = {
      enable = true;
      group = "media";
    };
    radarr = {
      enable = true;
      group = "media";
    };

    rtorrent = {
      enable = true;
      # package = unstable.rtorrent;
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
        schedule2 = data_permission,0,0,"execute.nothrow=chgrp,media,/srv/downloads"

        system.umask.set = 000

        trackers.use_udp.set = 1

        # KB/s - Limit upload to prevent IO overload
        upload_rate = 30

        # https://github.com/jesec/flood/issues/887
        method.redirect=load.throw,load.normal
        method.redirect=load.start_throw,load.start
        method.insert=d.down.sequential,value|const,0
        method.insert=d.down.sequential.set,value|const,0
      '';
    };
  };

  systemd.services = {
    rtorrent = {
      serviceConfig = {
        # https://github.com/NixOS/nixpkgs/issues/444923#issuecomment-3315988352
        LimitNOFILE = 10240;
        # Allow chown/chmod syscalls needed for permission management
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "@chown"
        ];
      };
    };
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
