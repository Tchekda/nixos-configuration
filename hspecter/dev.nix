{ config, pkgs, ... }:
let
  unstable = import ../unstable.nix { config.allowUnfree = true; };
in
{
  networking.extraHosts = ''
    ::1 avenir.local
    ::1 phpinfo.local
  '';

  users.users.tchekda.extraGroups = [ "www-data" ];

  services.nginx = {
    enable = true;

    virtualHosts = let vhost = config: ({
      http2 = true;
    } // config); in
      {
        "avenir.local" = vhost {
          root = "/var/www/Avenir/backend/public";
          locations = {
            "/" = {
              index = "index.php";
              tryFiles = "$uri $uri/ /index.php$is_args$args";
            };
            "~ /.*\.php$" = {
              extraConfig = ''
                fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
                fastcgi_index index.php;
              '';
            };
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
      user = config.services.nginx.group;
      settings = {
        pm = "dynamic";
        "listen.owner" = config.services.nginx.user;
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
        "pm.max_requests" = 500;
        "security.limit_extensions" = "";
      };
    };
    phpOptions = ''
      opcache.enable=0
      date.timezone = Europe/Paris
    '';
  };
}
