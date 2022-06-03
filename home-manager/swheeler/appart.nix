{ pkgs, config, lib, ... }:
let
  secrets = import ./appart.secrets.nix;
in
{
  systemd.user.services.runner = {
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
    Unit = {
      After = [ "network.target" ];
      Description = "Python Script runner";
    };
    Service = {
      ExecStart = ''
        /home/tchekda/appart/venv/bin/python3 main.py 
      '';
      WorkingDirectory = "/home/tchekda/appart";
      Restart = "on-failure";
      Environment = [ "SMS_USER=${secrets.SMS_USER}" "SMS_PASS=${secrets.SMS_PASS}" ];
    };
  };
}
