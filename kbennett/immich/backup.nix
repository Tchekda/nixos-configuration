{ pkgs, ... }:
let
  secrets = import ./secrets.nix;
in
{
  # https://doc.ubuntu-fr.org/curlftpfs#montage_automatique
  # fileSystems."/fbx" = {
  #   device = "${pkgs.curlftpfs}/bin/curlftpfs#${secrets.BACKUP_SERVER}";
  #   fsType = "fuse";
  #   options = [ "ssl" "rw" "allow_other" ];
  # };
  # networking.firewall.extraCommands = ''
  #   ${pkgs.iptables}/bin/ip6tables -A INPUT -s 2a01:e0a:7a:640::1 -j ACCEPT
  # '';

  systemd = {
    services = {
      immich-backup-job =
        let
          SRC_DIR = "/srv/immich-upload";
          DST_DIR = "/Freebox/Photos/Backup-Immich";
          lfptScript = pkgs.writeText "lftp-script" ''
            set net:reconnect-interval-base 1
            set net:reconnect-interval-max 1
            set net:reconnect-interval-multiplier 1
            set net:max-retries 3
            set net:persist-retries 3
            open ${secrets.PHOTO_BACKUP_SERVER}
            mirror  --continue --reverse --delete --only-newer --verbose=3 --parallel=10 --use-cache --no-perms --no-umask --no-empty-dirs --exclude upload/ --exclude encoded-video/ --exclude thumbs/ --exclude=.immich ${SRC_DIR} ${DST_DIR}
            exit
          '';
        in
        {
          after = [ "network.target" ];
          description = "Backup immich folders";
          serviceConfig = {
            ExecStart = "${pkgs.lftp}/bin/lftp -f ${lfptScript}";
          };
        };
      immich-db-backup-export-job =
        let
          SRC_DIR = "/srv/immich-db-backup";
          DST_DIR = "/immich-db-backup";
          lfptScript = pkgs.writeText "lftp-script" ''
            open ${secrets.DB_BACKUP_SERVER}
            mirror --continue --reverse --delete --only-newer --no-symlinks --verbose=3 --parallel=10 --use-cache --no-perms ${SRC_DIR} ${DST_DIR}
            exit
          '';
        in
        {
          after = [ "network.target" ];
          description = "Backup immich database";
          serviceConfig = {
            ExecStart = "${pkgs.lftp}/bin/lftp -f ${lfptScript}";
          };
        };
    };

    timers = {
      immich-backup-job = {
        description = "Trigger a backup of immich folders";

        timerConfig = {
          OnCalendar = "*-*-* 04:00:00";
          Persistent = true;
          Unit = "immich-backup-job.service";
        };

        wantedBy = [ "timers.target" ];
      };
      immich-db-backup-export-job = {
        description = "Trigger a backup of immich database";

        timerConfig = {
          OnCalendar = "*-*-* 06:00:00";
          Persistent = true;
          Unit = "immich-db-backup-export-job.service";
        };

        wantedBy = [ "timers.target" ];
      };
    };
  };


  virtualisation.oci-containers.containers.immich_db_backup = {
    image = "prodrigestivill/postgres-backup-local";
    volumes = [
      "/srv/immich-db-backup:/backups"
    ];
    user = "postgres:postgres";
    environment = {
      POSTGRES_HOST = "immich_postgres";
      POSTGRES_USER = secrets.DB_USERNAME;
      POSTGRES_PASSWORD = secrets.DB_PASSWORD;
      POSTGRES_DB = secrets.DB_DATABASE_NAME;
      POSTGRES_EXTRA_OPTS = "-Z1 --schema=public --blobs";
      SCHEDULE = "@daily";
      BACKUP_ON_START = "TRUE";
      BACKUP_KEEP_DAYS = "3";
      BACKUP_KEEP_WEEKS = "1";
      BACKUP_KEEP_MONTHS = "1";
      HEALTHCHECK_PORT = "8080";
    };
    dependsOn = [ "immich_postgres" ];
    extraOptions = [ "--network=immich" ];
  };
}
