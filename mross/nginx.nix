{ pkgs, ... }:
let
  vhostWith = config: extra: ({
    http2 = true;
    forceSSL = true;
    sslCertificate = "/etc/cf-cert";
    sslCertificateKey = "/etc/cf-key";
    extraConfig = ''
      ssl_client_certificate /etc/origin-pull-ca;
      ssl_verify_client on;

      add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
      add_header X-Content-Type-Options "nosniff" always;
      add_header X-Frame-Options "SAMEORIGIN" always;
      add_header Referrer-Policy "no-referrer-when-downgrade" always;

      # Websockets
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";

      ${extra}
    '';
  } // config);
  folderWith = path: extra: vhostWith { root = path; } extra;
  proxyWith = address: extra: vhost { locations."/" = { proxyPass = address; extraConfig = extra; }; };

  appFolder = path: vhost {
    root = path;
    locations."/" = { tryFiles = "$uri $uri/ /index.html"; };
  };

  vhost = config: vhostWith config "";
  folder = path: folderWith path "";
  proxy = address: proxyWith address ''
    proxy_http_version 1.1;

    proxy_set_header Upgrade $http_upgrade;

    proxy_set_header Connection $http_connection;
  '';
in
{
  networking = {
    firewall = {
      allowedTCPPorts = [ 443 ];
    };
    interfaces.lo = {
      ipv6 = {
        addresses = [
          { address = "2001:bc8:2e2a:2::1"; prefixLength = 128; }
        ];
      };
    };
  };
  services.nginx = {
    commonHttpConfig = ''
      ssl_ecdh_curve secp384r1;
      add_header Expect-CT "max-age=0";
      charset UTF-8;
    '';
    defaultListenAddresses = [ "0.0.0.0" "[2001:bc8:2e2a:2::1]" ];
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "lg42.tchekda.fr" = proxy "http://127.0.0.1:5050";
      "plex.tchekda.fr" = proxyWith "http://localhost:32400/" ''
        #Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
        send_timeout 100m;
        # Plex has A LOT of javascript, xml and html. This helps a lot, but if it causes playback issues with devices turn it off.
        gzip on;
        gzip_vary on;
        gzip_min_length 1000;
        gzip_proxied any;
        gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
        gzip_disable "MSIE [1-6]\.";

        # Nginx default client_max_body_size is 1MB, which breaks Camera Upload feature from the phones.
        # Increasing the limit fixes the issue. Anyhow, if 4K videos are expected to be uploaded, the size might need to be increased even more
        client_max_body_size 100M;

        # Plex headers
        proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
        proxy_set_header X-Plex-Device $http_x_plex_device;
        proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
        proxy_set_header X-Plex-Platform $http_x_plex_platform;
        proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
        proxy_set_header X-Plex-Product $http_x_plex_product;
        proxy_set_header X-Plex-Token $http_x_plex_token;
        proxy_set_header X-Plex-Version $http_x_plex_version;
        proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
        proxy_set_header X-Plex-Provides $http_x_plex_provides;
        proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
        proxy_set_header X-Plex-Model $http_x_plex_model;

        # Websockets
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Buffering off send to the client as soon as the data is received from Plex.
        proxy_redirect off;
        proxy_buffering off;
      '';
      "radarr.tchekda.fr" = proxy "http://127.0.0.1:7878";
      "seedbox.tchekda.fr" = vhost {
        locations = {
          "/".proxyPass = "http://127.0.0.1:3000";
          "/RPC2".extraConfig = ''
            allow 127.0.0.1;
            allow ::1;
            deny all;
            include ${pkgs.nginx}/conf/scgi_params;
            scgi_pass unix:/run/rtorrent/rpc.sock;
          '';
        };
      };
      "sonarr.tchekda.fr" = proxy "http://127.0.0.1:8989";
      "tchekda.fr" = vhostWith { default = true; } ''
        return 301 https://www.tchekda.fr$request_uri;
      '';
    };
  };
  # Temp fix https://github.com/NixOS/nixpkgs/issues/87698#issuecomment-971505170
  systemd.tmpfiles.rules = [
    "Z '/var/cache/nginx' 0750 nginx nginx -"
  ];
}
