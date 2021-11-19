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
        # forceSSL = true;
        # enableACME = true;
        extraConfig = ''
          proxy_buffering off;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8123";
          proxyWebsockets = true;
        };
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    email = "contact@tchekda.fr";
  };
}
