{ config, pkgs, lib, ... }:
let
  script = pkgs.writeShellScriptBin "redeploy" ''
    ${pkgs.docker}/bin/docker pull ghcr.io/tchekda/upforlove:latest && \
    ${pkgs.docker}/bin/docker stop upforlove || \ 
    ${pkgs.docker}/bin/docker rm -f upforlove || \ 
    ${pkgs.docker}/bin/docker run -d -p 127.0.0.1:3001:3000 --name upforlove ghcr.io/tchekda/upforlove:latest
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
          "response-message": "Redeploying UFL server."
        }
      ]
    '';
    user = "webhook";
    group = "webhook";
  };

  systemd.services = {
    webhook-runner = {
      enable = true;
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
    
