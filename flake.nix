{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-nix = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    claude-desktop = {
        url = "github:blahutakrystian/claude-desktop-linux-flake";
        inputs = {
            nixpkgs.follows = "nixpkgs";
            flake-utils.follows = "flake-utils";
          };
      };
  };

  outputs = inputs@{ nixpkgs, home-manager, nvf, catppuccin-nix,
  claude-desktop, 
  ... }: {
    nixosConfigurations = {
      nixos-ftw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
	          home-manager.users.krystian = {  ... }: {
               imports = [
	          ./home.nix
	          nvf.homeManagerModules.default 
                  catppuccin-nix.homeManagerModules.catppuccin
	          ];

            # Add Claude Desktop to your home packages
            home.packages = [ claude-desktop.packages.x86_64-linux.claude-desktop ];
            };


            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
