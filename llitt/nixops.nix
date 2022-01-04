{
  network = {
    description = "Raspberry Pi";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };
  llitt =
    {
      deployment = {
        targetEnv = "none";
        targetHost = "llitt";
      };

      nixpkgs = {
        system = "aarch64-linux";
      };

      imports = [ ./configuration.nix ];
    };
}
