{
  # Describe your "deployment"
  network = {
    description = "Scaleway Dedibox";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };

  mross = {
    deployment = {
      targetEnv = "none";
      targetHost = "163.172.50.165";
      targetPort = 9137;
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
      zone-tchekda-dn42 = {
        text = builtins.readFile ./dn42/zones/tchekda.dn42;
        target = "zones/tchekda.dn42";
        user = "named";
        group = "named";
      };
      zone-ipv4-reverse = {
        text = builtins.readFile ./dn42/zones/ipv4.reverse;
        target = "zones/ipv4.reverse";
        user = "named";
        group = "named";
      };
      zone-ipv6-reverse = {
        text = builtins.readFile ./dn42/zones/ipv6.reverse;
        target = "zones/ipv6.reverse";
        user = "named";
        group = "named";
      };
      hockey-pen-stats-env = {
        text = builtins.readFile ./hockey-pen-stats.env;
        target = "hockey-pen-stats.env";
        user = "nginx";
        group = "nginx";
      };
    };

    imports = [ ./configuration.nix ];
  };
}
