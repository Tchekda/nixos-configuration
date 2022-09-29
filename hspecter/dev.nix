{ config, pkgs, ... }:
let
  customPHP8 = pkgs.php80.buildEnv {
    extraConfig =
      ''date.timezone = Europe/Paris
          memory_limit = 1G'';
    extensions = { enabled, all }: enabled ++ [ all.xdebug ];
  };
in
{

  environment.systemPackages = [ customPHP8 ];

  networking.extraHosts = ''
    ::1 avenir.local
    127.0.0.1 dev.ivao.aero
  '';

  users.users.tchekda.extraGroups = [ "www-data" ];

  services = {
    nginx = {
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
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureUsers = [{ name = "root"; }];
      initialDatabases = [{ name = "avenir"; }];
      settings.mysqld.bind-address = "127.0.0.1";
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      ensureUsers = [{
        name = "tchekda";
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }];
    };

    phpfpm = {
      phpPackage = customPHP8;
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
        max_execution_time = 120
        post_max_size = 500M
        upload_max_filesize = 500M
        memory_limit = 1G
        xdebug.client_port = 9003
      '';
    };
  };
}
