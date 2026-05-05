{
	description =  "Configuracion Dank de Mia";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		dms = {
			url = "github:AvengeMedia/DankMaterialShell/stable";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs,dms,...}@inputs: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
				dms.nixosModules.default
			];
		};
	};
}
