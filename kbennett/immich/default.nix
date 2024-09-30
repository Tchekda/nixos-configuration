{ pkgs, config, ... }:
let
  secrets = import ./secrets.nix;
  DB_USERNAME = "immich";
  DB_DATABASE_NAME = "postgres";
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
          DB_USERNAME = DB_USERNAME;
          DB_PASSWORD = secrets.DB_PASSWORD;
          DB_DATABASE_NAME = DB_DATABASE_NAME;
          REDIS_HOSTNAME = "immich_redis";
          TZ = "Europe/Paris";
        };
        ports = [
          "127.0.0.1:2283:3001"
        ];
        dependsOn = [ "immich_redis" "immich_postgres" ];
        extraOptions = [ "--network=immich" ];
      };
      immich_redis = {
        image = "docker.io/redis:6.2-alpine@sha256:2d1463258f2764328496376f5d965f20c6a67f66ea2b06dc42af351f75248792";
        extraOptions = [ "--network=immich" ];
      };
      immich_postgres = {
        image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
        environment = {
          POSTGRES_USER = DB_USERNAME;
          POSTGRES_PASSWORD = secrets.DB_PASSWORD;
          POSTGRES_DB = DB_DATABASE_NAME;
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
