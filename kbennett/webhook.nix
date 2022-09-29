{ config, pkgs, lib, ... }:
let
  script = pkgs.writeShellScriptBin "redeploy" ''
    ${pkgs.docker}/bin/docker pull IMAGE && \
    ${pkgs.docker}/bin/docker stop NAME || \ 
    ${pkgs.docker}/bin/docker rm -f NAME || \ 
    ${pkgs.docker}/bin/docker run -d -p 127.0.0.1:8001:80 --name NAME IMAGE
  '';
in
{
  environment.etc.webhook-config = {
    text = ''
      [
        {
          "id": "redeploy",
          "execute-command": "${script}/bin/redeploy",
          "command-working-directory": "/home/webhook",
          "response-message": "Redeploying Container."
        }
      ]
    '';
    user = "webhook";
    group = "webhook";
  };

  systemd.services = {
    webhook-runner = {
      enable = false;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc.webhook-config.source ];
      description = "Webhook listener";
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        User = "webhook";
        Group = "webhook";
      };
      script = ''
        ${pkgs.webhook}/bin/webhook \
          -hooks ${config.environment.etc.webhook-config.source} \
          -verbose
      '';
    };
  };

  users = {
    groups.webhook = { };
    users.webhook = {
      description = "Webhook user";
      extraGroups = [ "docker" ];
      group = "webhook";
      isNormalUser = true; # Keep docker credentials
    };
  };
}
    
