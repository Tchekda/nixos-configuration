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
        enableSSL = false;
        # forceSSL = true;
        # enableACME = true;
        extraConfig = ''
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
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@tchekda.fr";
  };
}
