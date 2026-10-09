{
  description = "Joel's NixOS and macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hatter = {
      url = "github:Mibea/Hatter";
      flake = false;
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      # Umbriel tracks wlroots more closely than the release channel does.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "homebrew-brew";
    };

    homebrew-brew = {
      url = "github:Homebrew/brew/7.0.9";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      apple-fonts,
      hatter,
      home-manager,
      nix-darwin,
      nix-homebrew,
      homebrew-brew,
      self,
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
      apps.aarch64-darwin.darwin-rebuild = {
        type = "app";
        program = "${self.darwinConfigurations.macbook.system}/sw/bin/darwin-rebuild";
        meta.description = "Build and activate the macbook configuration";
      };

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/macbook/default.nix
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            # Retain the installed Brew version instead of nix-homebrew's older default.
            nix-homebrew.package = homebrew-brew // {
              name = "brew-7.0.9";
              version = "7.0.9";
            };
            home-manager.extraSpecialArgs.pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-darwin";
            };
          }
        ];
      };

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
                inherit
                  noctalia
                  umbriel
                  pkgs-unstable
                  apple-fonts
                  hatter
                  ;
              };

              users.joel = import ./hosts/baremetal/home.nix;
            };
          }
        ];
      };
    };
}
