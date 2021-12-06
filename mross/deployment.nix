{
  # Describe your "deployment"
  network.description = "Scaleway Dedibox";
  # A single machine description.
  lgpserver = {
    deployment = {
      targetEnv = "libvirtd";
      libvirtd.imageDir = "/var/lib/libvirt/images";
    };

    imports = [ ./configuration.nix ];
  };
}
