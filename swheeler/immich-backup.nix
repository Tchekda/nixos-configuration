{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/fbx" = {
    device = "//192.168.0.254/Freebox";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in
      [ automount_opts ];
  };
  systemd = {
    services = {
      immich-backup-job =
        let
          rsyncExclude = pkgs.writeText "rsync-exclude" ''
            encoded-video/
            thumbs/
            .immich
            library/2bfeb95a-a27a-4d82-95f9-23440d704084/
          '';
        in
        {
          after = [ "network.target" ];
          description = "Backup immich folders";
          serviceConfig = {
            ExecStart = "${pkgs.rsync}/bin/rsync -e '${pkgs.openssh}/bin/ssh' -rthvzP --stats --exclude-from=${rsyncExclude} root@photo.tchekda.fr:/srv/immich-upload/ /mnt/fbx/Photos/Backup-Immich/";
          };
        };
    };

    timers.immich-backup-job = {
      description = "Trigger a backup of immich folders";

      timerConfig = {
        OnCalendar = "*-*-* 04:00:00";
        Persistent = true;
        Unit = "immich-backup-job.service";
      };

      wantedBy = [ "timers.target" ];
    };
  };
}
