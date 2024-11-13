{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
  let
    ful = flake-utils.lib;
  in
    ful.eachSystem [ful.system.x86_64-linux ful.system.aarch64-linux] (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = {
        image = nixos-generators.nixosGenerate {
          inherit pkgs;
          modules = [
            ./lima.nix
          ];
          format = "raw-efi";
        };
      };
    })
    // {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = attrs;
        modules = [
          ./lima.nix
          ./user-config.nix
          lix-module.nixosModules.lixFromNixpkgs
        ];
      };

      nixosModules.lima = {
        imports = [./lima.nix];
      };
    };
}
