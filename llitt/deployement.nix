{
  network.description = "Raspberry Pi";
  pi =
    {
      deployment = {
        targetEnv = "libvirtd";
        libvirtd = {
          headless = true;
        };
      };

      imports = [ ./configuration.nix ];
    };
}
