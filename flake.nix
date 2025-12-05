{
  description = "hspecter system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list where available
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      unstable,
      ...
    }@inputs:
    rec {
      # nixos-rebuild switch --flake /home/tchekda/nixos-configuration#hspecter
      nixosConfigurations = {
        hspecter = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
            ./hspecter/configuration.nix
          ];
          specialArgs = {
            unstable = import unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        };
      };

      # home-manager switch --flake /home/tchekda/nixos-configuration#hspecter
      homeConfigurations = {
        hspecter = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-manager/hspecter/default.nix ];
          extraSpecialArgs = {
            unstable = import unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        };
      };
    };
}
