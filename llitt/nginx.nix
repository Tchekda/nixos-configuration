{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "pi.hole" = {
        default = true;
        http2 = true;
        enableSSL = false;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3080";
        };
      };
      "ha.tchekda.fr" = {
        http2 = true;
        addSSL = true;
        sslCertificate = "/etc/cf-cert";
        sslCertificateKey = "/etc/cf-key";
        extraConfig = ''
          ssl_client_certificate /etc/origin-pull-ca;
          ssl_verify_client on;
          proxy_buffering off;
          error_log /var/log/nginx/error.log debug;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8123";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
          '';
        };
      };
      "solver.tchekda.fr" = {
        default = false;
        http2 = true;
        enableSSL = false;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8191";
        };
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@tchekda.fr";
  };
}
