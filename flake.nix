{
  description = "hspecter system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs25_05.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list where available
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list where available
    };
    # system-level software and settings (macOS)
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declarative homebrew management
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs25_05,
      nixos-hardware,
      home-manager,
      unstable,
      vscode-server,
      darwin,
      nix-homebrew,
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
        # Not working as some files are not in the git history (dn42 wg tunnels)
        # mross = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [
        #     home-manager.nixosModules.home-manager
        #     vscode-server.nixosModules.default
        #     ./mross/configuration.nix
        #   ];
        #   specialArgs = {
        #     unstable = import unstable {
        #       system = "x86_64-linux";
        #       config.allowUnfree = true;
        #     };
        #   };
        # };
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
            nixpkgs25_05 = nixpkgs25_05.legacyPackages.x86_64-linux;
          };
        };
      };

      # $ darwin-rebuild build --flake .#<name>
      darwinConfigurations."rzane" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          nix-homebrew.darwinModules.default
          home-manager.darwinModules.home-manager
          ./rzane/configuration.nix
        ];
      };
    };
}
