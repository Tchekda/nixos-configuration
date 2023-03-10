{ pkgs, config, ... }:
{
  users.users.tchekda.extraGroups = [ "docker" ];
  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--ipv6 --fixed-cidr-v6 2001:bc8:2e2a:1::/64";
    };
    oci-containers = {
      backend = "docker";
      containers = {
        flood = {
          image = "jesec/flood";
          cmd = [ "--allowedpath /srv" ];
          user = "995:994"; #rtorrent:media
          ports = [
            "127.0.0.1:3000:3000"
          ];
          volumes = [
            # Do not forget to chown rtorrent:media /etc/flood
            "/etc/flood/config:/config"
            "/srv:/srv"
            "/run/rtorrent/rpc.sock:/run/rtorrent/rpc.sock"
          ];
          environment = {
            HOME = "/config";
          };
        };
      };
    };
  };
}
