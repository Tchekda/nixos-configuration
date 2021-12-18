{
  # Describe your "deployment"
  network = {
    description = "Delta Server";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };

  # A single machine description.
  swheeler = { config, lib, pkgs, ... }: {
    deployment = {
      targetEnv = "none";
      targetHost = "delta";
      targetPort = 2217;
    };

    nixpkgs = {
      system = "aarch64-linux";
    };

    imports = [ ./configuration.nix ];
  };
}
