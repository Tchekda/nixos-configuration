{
  network = {
    description = "Raspberry Pi";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };
  llitt = {
    deployment = {
      targetEnv = "none";
      targetHost = "192.168.0.144";
      targetPort = 22;
    };

    nixpkgs = {
      system = "aarch64-linux";
    };

    imports = [ ./configuration.nix ];

    environment.etc = {
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
  };
}
