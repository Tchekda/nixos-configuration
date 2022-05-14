{
  # Describe your "deployment"
  network = {
    description = "Scaleway Dedibox";
    storage.legacy = {
      databasefile = "~/.nixops/deployments.nixops";
    };
  };

  vm = {
    deployment = {
      targetEnv = "none";
      targetHost = "163.172.50.165";
      targetPort = 22201;
    };
    environment.etc = {
      deluge-auth = {
        text = builtins.readFile ./vm/deluge-auth;
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

    imports = [ ./vm/configuration.nix ];
  };

  ct = {
    deployment = {
      targetEnv = "none";
      targetHost = "163.172.50.165";
      targetPort = 22102;
    };
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
      zone-tchekda-dn42 = {
        text = builtins.readFile ./ct/dn42/zones/tchekda.dn42;
        target = "zones/tchekda.dn42";
        user = "named";
        group = "named";
      };
      zone-ipv4-reverse = {
        text = builtins.readFile ./ct/dn42/zones/ipv4.reverse;
        target = "zones/ipv4.reverse";
        user = "named";
        group = "named";
      };
      zone-ipv6-reverse = {
        text = builtins.readFile ./ct/dn42/zones/ipv6.reverse;
        target = "zones/ipv6.reverse";
        user = "named";
        group = "named";
      };
    };

    imports = [ ./ct/configuration.nix ];
  };
}
