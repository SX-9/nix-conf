{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, ... }: let
    hostname = "thinkpad-l450";
    username = "satr14";
  in {
    homeConfigurations = {
      main = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit username;
        };
        modules = [
          ./home/main.nix
          ./home/dconf.nix  
        ];
      };
    };
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
        };
        modules = [
          ./lib/sys.nix
          ./lib/user.nix
        ];
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
        };
        modules = [
          ./lib/sys.nix
          ./lib/user.nix
          ./hw/extras.nix
        ];
      };
    };
  };
}
