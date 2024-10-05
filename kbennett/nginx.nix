{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services = {
    nginx = {
      enable = true;
      logError = "stderr debug";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "avenir.tchekda.fr" = {
          default = true;
          http2 = true;
          onlySSL = true;
          sslCertificate = "/var/certs/cf-cert.pem";
          sslCertificateKey = "/var/certs/cf-key.pem";
          extraConfig = ''
            ssl_client_certificate /var/certs/origin-pull-ca.pem;
            ssl_verify_client on;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
          };
        };
        "jackett.tchekda.fr" = {
          http2 = true;
          onlySSL = true;
          sslCertificate = "/var/certs/cf-cert.pem";
          sslCertificateKey = "/var/certs/cf-key.pem";
          extraConfig = ''
            ssl_client_certificate /var/certs/origin-pull-ca.pem;
            ssl_verify_client on;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:9117";
          };
        };
        "moodle.tchekda.fr" = {
          root = "/var/www/moodle";
          http2 = true;
          onlySSL = true;
          sslCertificate = "/var/certs/cf-cert.pem";
          sslCertificateKey = "/var/certs/cf-key.pem";
          extraConfig = ''
            ssl_client_certificate /var/certs/origin-pull-ca.pem;
            ssl_verify_client on;
          '';
          locations."/" = {
            index = "index.php";
            tryFiles = "$uri $uri/ =404";
          };
          locations."~ [^/]\.php(/|$)" = {
            extraConfig = ''
              fastcgi_index index.php;
              fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
              fastcgi_split_path_info  ^(.+\.php)(/.+)$;
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_param   PATH_INFO       $fastcgi_path_info;
              fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
          };
        };
        "photo.tchekda.fr" = {
          http2 = true;
          http3 = true;
          enableACME = true;
          forceSSL = true;
          extraConfig = ''
            client_body_temp_path /srv/nginx-tmp 1 2;
            client_max_body_size 50000M;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            send_timeout       600s;
          '';
          locations."/" = {
            proxyWebsockets = true;
            proxyPass = "http://127.0.0.1:2283";
          };
        };
        "photo-v4.tchekda.fr" = {
          http2 = true;
          http3 = true;
          extraConfig = ''
            client_body_temp_path /srv/nginx-tmp 1 2;
            client_max_body_size 50000M;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            send_timeout       600s;
          '';
          locations."/" = {
            proxyWebsockets = true;
            proxyPass = "http://127.0.0.1:2283";
          };
        };
      };
    };
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureUsers = [{ name = "root"; }];
      initialDatabases = [{ name = "moodle"; }];
      settings.mysqld.bind-address = "localhost";
    };
    phpfpm = {
      phpPackage = pkgs.php81;
      pools.www = {
        user = config.services.nginx.group;
        settings = {
          pm = "dynamic";
          "listen.owner" = config.services.nginx.user;
          "pm.max_children" = 5;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 3;
          "pm.max_requests" = 500;
          "security.limit_extensions" = ".php";
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
        };
        phpEnv."PATH" = lib.makeBinPath [ pkgs.php81 ];
      };
      phpOptions = ''
        opcache.enable=1
        date.timezone = Europe/Paris
        max_execution_time = 120
        post_max_size = 500M
        upload_max_filesize = 500M
        memory_limit = 1G
        max_input_vars = 10000
      '';
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@tchekda.fr";
  };
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/srv/nginx-tmp" ];
}
