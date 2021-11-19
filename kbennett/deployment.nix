{
  # Describe your "deployment"
  #   network.description = "Web server";

  # A single machine description.
  lgpserver = {
    deployment = {
      targetEnv = "none";
      targetHost = "2a01:cb05:8fdb:2555:e490:e2ff:fe7b:497e";
    };

    imports = [ ./configuration.nix ];
  };
}
