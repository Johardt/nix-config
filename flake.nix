{
  description = "Joel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel = {
      # Umbriel uses git submodules; Nix 2.34 cannot enable those through the
      # github: fetcher used by the shorter URL form.
      url = "git+https://github.com/noctalia-dev/umbriel?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      disko,
      noctalia,
      noctalia-greeter,
      umbriel,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      apps.${system}.disko = {
        type = "app";
        program = "${disko.packages.${system}.disko}/bin/disko";
        meta.description = "Apply the baremetal Disko layout";
      };

      # Installation-time disk layout. This is intentionally separate from the
      # live NixOS module because the current installation predates this layout.
      diskoConfigurations.baremetal = import ./hosts/baremetal/disko.nix;

      nixosConfigurations.baremetal = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };

        modules = [
          ./hosts/baremetal/configuration.nix
          noctalia-greeter.nixosModules.default
          umbriel.nixosModules.default

          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit noctalia umbriel pkgs-unstable;
              };

              users.joel = import ./home/joel.nix;
            };
          }
        ];
      };
    };
}
