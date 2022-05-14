{
  # Describe your "deployment"
  network = {
    description = "LGP VM";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };

  # A single machine description.
  kbennett = {
    deployment = {
      targetEnv = "none";
      targetHost = "lgp";
    };

    environment.etc = {
      ufl-htpasswd = {
        text = builtins.readFile ./ufl.htpasswd;
        user = "nginx";
        group = "nginx";
      };
    };

    imports = [ ./configuration.nix ];
  };
}
