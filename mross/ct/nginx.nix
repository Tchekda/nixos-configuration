{ config, ... }:
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
  # Temp fix https://github.com/NixOS/nixpkgs/issues/87698#issuecomment-971505170
  systemd.tmpfiles.rules = [
    "Z '/var/cache/nginx' 0750 nginx nginx -"
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      ssl_session_timeout 1d;
      ssl_session_cache shared:MozSSL:10m;
      ssl_session_tickets off;
      ssl_prefer_server_ciphers off;

      # Disabled because CF Origin CA 
      # ssl_stapling on;
      # ssl_stapling_verify on;

      ssl_ecdh_curve secp384r1;

      add_header Expect-CT "max-age=0";

      charset UTF-8;
    '';

    virtualHosts = {
      "dn42.tchekda.fr" = proxy "http://192.168.1.101";
      "files.tchekda.fr" = appFolder "/var/www/files.tchekda.fr/";
      "lg42.tchekda.fr" = proxy "http://192.168.1.101:5000";
      # "lg42.tchekda.fr" = proxy "http://127.0.0.1:5000";
      "pac.tchekda.fr" = folderWith "/var/www/pac.tchekda.fr/" ''
        auth_basic "Security";
        auth_basic_user_file /var/www/pac.tchekda.fr/.htpasswd;
      '';
      "plex.tchekda.fr" = proxyWith "http://192.168.1.201" ''
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
      proxmox_web_ui = {
        http2 = true;
        onlySSL = true;
        serverName = "pve.tchekda.fr";
        serverAliases = [ "sd-102001.dedibox.fr" ];
        locations."/" = { proxyPass = "https://192.168.1.1:8006"; };
        sslCertificate = "/etc/ssl/pveproxy-ssl.pem"; # Copied by SCP from pve host
        sslCertificateKey = "/etc/ssl/pveproxy-ssl.key";
      };
      proxmox_cert = {
        http2 = true;
        serverName = "pve.tchekda.fr";
        serverAliases = [ "sd-102001.dedibox.fr" ];
        locations."/" = {
          proxyPass = "http://192.168.1.1:80";
        };
      };
      "radarr.tchekda.fr" = proxy "http://192.168.1.201";
      "seedbox.tchekda.fr" = proxy "http://192.168.1.201";
      "sonarr.tchekda.fr" = proxy "http://192.168.1.201";
      smtp_web_ui = {
        http2 = true;
        serverName = "smtp.tchekda.fr";
        serverAliases = [
          "autoconfig.tchekda.fr"
          "autodiscover.tchekda.fr"
        ];
        enableACME = true;
        onlySSL = true;
        locations."/" = {
          proxyPass = "https://192.168.1.200";
          extraConfig = ''client_max_body_size 100M;'';
        };
      };
      smtp_cert = {
        http2 = true;
        serverName = "smtp.tchekda.fr";
        locations."/" = { proxyPass = "http://192.168.1.200"; };
      };
      "znc.tchekda.fr" = {
        http2 = true;
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://192.168.1.101:1722"; };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@tchekda.fr";
  };
}
