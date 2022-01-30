{
  # Describe your "deployment"
  network = {
    description = "Scaleway Dedibox";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };

  media = {
    deployment = {
      targetEnv = "none";
      targetHost = "2001:bc8:2e2a:201::1";
      targetPort = 22201;
    };
    environment.etc = {
      deluge-auth = {
        text = builtins.readFile ./deluge-auth;
        user = "deluge";
        group = "deluge";
      };
      cf-cert = {
        text = builtins.readFile ../ssl/cf-cert.pem;
        user = "nginx";
        group = "nginx";
      };
      cf-key = {
        text = builtins.readFile ../ssl/cf-key.pem;
        user = "nginx";
        group = "nginx";
      };
      origin-pull-ca = {
        text = builtins.readFile ../ssl/origin-pull-ca.pem;
        user = "nginx";
        group = "nginx";
      };
    };

    imports = [ ./configuration.nix ];
  };
}
