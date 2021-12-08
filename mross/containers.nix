{ pkgs, config, ... }:
{

  virtualisation.oci-containers.containers = {
    flood = {
      image = "jesec/flood";
      cmd = [ "--allowedpath /srv" ];
      user = "998:995";
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
}
