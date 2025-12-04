{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
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
        "bybit.tchekda.fr" = {
          http2 = true;
          onlySSL = true;
          sslCertificate = "/var/certs/cf-cert.pem";
          sslCertificateKey = "/var/certs/cf-key.pem";
          extraConfig = ''
            ssl_client_certificate /var/certs/origin-pull-ca.pem;
            ssl_verify_client on;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:5000";
          };
        };
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@tchekda.fr";
  };
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/srv/nginx-tmp" ];
}
