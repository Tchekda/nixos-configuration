{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/77d190f10931c1d06d87bf6d772bf65346c71777)
    { config = config.nixpkgs.config; };
in
{
  networking.extraHosts = ''
    ::1 avenir.local
    ::1 phpinfo.local
  '';

  services.nginx = {
    enable = true;

    # recommendedGzipSettings = true;
    # recommendedOptimisation = true;
    # recommendedProxySettings = true;

    virtualHosts = let vhost = config: ({
      http2 = true;
      # extraConfig = ''
      #   charset UTF-8;
      # '';
    } // config); in
      {
        "avenir.local" = vhost {
          root = "/var/www/Avenir/backend/public";
          locations."/" = {
            index = "index.php";
            tryFiles = "$uri $uri/ /index.php$is_args$args";
            extraConfig = ''
              fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
              fastcgi_index index.php;
            '';
          };
        };
        "phpinfo.local" = vhost {
          root = "/var/www/phpinfo";
          locations."/" = {
            index = "index.php";
            extraConfig = ''
              fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
              fastcgi_index index.php;
            '';
          };
        };
      };
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialDatabases = [{ name = "avenir"; }];
    ensureUsers = [{ name = "root"; }];
  };
  services.phpfpm = {
    phpPackage = unstable.php80;
    pools.www = {
      user = "nobody";
      settings = {
        pm = "dynamic";
        "listen.owner" = config.services.nginx.user;
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
        "pm.max_requests" = 500;
      };
    };
    phpOptions = ''opcache.enable = 0'';
  };
}
