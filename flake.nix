{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    lix-module,
    flake-utils,
    nixos-generators,
    ...
  } @ attrs:
  # Create system-specific outputs for lima systems
  let
    ful = flake-utils.lib;
    username = "FIXME"; # Replace with real user
  in
    ful.eachSystem [ful.system.x86_64-linux ful.system.aarch64-linux] (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = {
        img = nixos-generators.nixosGenerate {
          inherit pkgs username;
          modules = [
            lix-module.nixosModules.lixFromNixpkgs
            ./lima.nix
          ];
          format = "raw-efi";
        };
      };
    })
    // {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux"; # doesn't play nice with each system :shrug:
        specialArgs = attrs;
        inherit username;
        modules = [
          lix-module.nixosModules.lixFromNixpkgs
          ./lima.nix
          ./user-config.nix
        ];
      };

      nixosModules.lima = {
        imports = [./lima.nix];
      };
    };
}
