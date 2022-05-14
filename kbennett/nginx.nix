{ ... }:

{
  services.nginx = {
    enable = true;
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
      "feedback.tchekda.fr" = {
        http2 = true;
        onlySSL = true;
        sslCertificate = "/var/certs/cf-cert.pem";
        sslCertificateKey = "/var/certs/cf-key.pem";
        extraConfig = ''
          ssl_client_certificate /var/certs/origin-pull-ca.pem;
          ssl_verify_client on;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8002";
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
      "upforlove.tchekda.fr" = {
        http2 = true;
        onlySSL = true;
        sslCertificate = "/var/certs/cf-cert.pem";
        sslCertificateKey = "/var/certs/cf-key.pem";
        extraConfig = ''
          ssl_client_certificate /var/certs/origin-pull-ca.pem;
          ssl_verify_client on;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            auth_basic "Security";
            auth_basic_user_file /etc/ufl-htpasswd; 
          '';
        };
      };
      "webhook.tchekda.fr" = {
        http2 = true;
        onlySSL = true;
        sslCertificate = "/var/certs/cf-cert.pem";
        sslCertificateKey = "/var/certs/cf-key.pem";
        extraConfig = ''
          ssl_client_certificate /var/certs/origin-pull-ca.pem;
          ssl_verify_client on;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
        };
      };
    };
  };
}
