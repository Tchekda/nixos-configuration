{ pkgs, config, ... }:
let
  secrets = import ./secrets.nix;
in
{
  systemd.services.init-immich-docker-network = {
    description = "Create the network bridge.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    script =
      let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in
      ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service.
        check=$(${dockercli} network ls | grep "immich" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create immich
        else
          echo "immich already exists in docker"
        fi
      '';
  };
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      # daemon.settings = {
      #   "data-root" = "/srv/docker-data";
      # };
    };
    oci-containers.containers = {
      immich_server = {
        image = "ghcr.io/immich-app/immich-server:release";
        volumes = [
          "/srv/immich-upload:/usr/src/app/upload"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          DB_HOSTNAME = "immich_postgres";
          DB_USERNAME = secrets.DB_USERNAME;
          DB_PASSWORD = secrets.DB_PASSWORD;
          DB_DATABASE_NAME = secrets.DB_DATABASE_NAME;
          REDIS_HOSTNAME = "immich_redis";
          TZ = "Europe/Paris";
        };
        ports = [
          "127.0.0.1:2283:2283"
        ];
        dependsOn = [ "immich_redis" "immich_postgres" ];
        extraOptions = [ "--network=immich" ];
      };
      immich_machine_learning = {
        image = "ghcr.io/immich-app/immich-machine-learning:release";
        volumes = [
          "/srv/immich-model-cache:/cache"
        ];
        extraOptions = [ "--network=immich" ];
      };
      immich_redis = {
        image = "docker.io/redis:6.2-alpine@sha256:eaba718fecd1196d88533de7ba49bf903ad33664a92debb24660a922ecd9cac8";
        extraOptions = [ "--network=immich" ];
      };
      immich_postgres = {
        image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
        environment = {
          POSTGRES_USER = secrets.DB_USERNAME;
          POSTGRES_PASSWORD = secrets.DB_PASSWORD;
          POSTGRES_DB = secrets.DB_DATABASE_NAME;
          POSTGRES_INITDB_ARGS = "'--data-checksums'";
        };
        volumes = [
          "/srv/immich-postgres:/var/lib/postgresql/data"
        ];
        cmd = [ "postgres" "-c" "shared_preload_libraries=vectors.so" "-c" "search_path=\"$$user\", public, vectors" "-c" "logging_collector=on" "-c" "max_wal_size=2GB" "-c" "shared_buffers=512MB" "-c" "wal_compression=on" ];
        extraOptions = [ "--network=immich" ];
      };

    };
  };
}
