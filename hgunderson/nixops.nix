{
  # Describe your "deployment"
  network = {
    description = "Russian VM";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };

  # A single machine description.
  hgunderson = {
    deployment = {
      targetEnv = "none";
      targetHost = "russia";
    };

    imports = [ ./configuration.nix ];
  };
}
