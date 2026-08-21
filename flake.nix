{
  description = "Joel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, disko, ... }:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    apps.${system}.disko = {
      type = "app";
      program = "${disko.packages.${system}.disko}/bin/disko";
    };

    # Installation-time disk layout. This is intentionally separate from the
    # live NixOS module because the current installation predates this layout.
    diskoConfigurations.baremetal = import ./hosts/baremetal/disko.nix;

    nixosConfigurations.baremetal = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs-unstable; };

      modules = [
        ./hosts/baremetal/configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit pkgs-unstable; };

            users.joel = import ./home/joel.nix;
          };
        }
      ];
    };
  };
}
