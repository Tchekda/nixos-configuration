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

    imports = [ ./configuration.nix ];
  };
}
