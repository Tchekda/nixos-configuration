# The Tempest
# System configuration for my desktop

{
  inputs,
  ...
}:

with inputs;

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
    ./configuration.nix
  ];
  specialArgs = {
    unstable = import inputs.unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
}
