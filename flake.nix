{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = inputs @ { nixpkgs, ... }: let
    hostname = "thinkpad-l450";
    username = "satr14";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit hostname;
        inherit username;
      };
      modules = [
        ./lib/sys.nix
        ./lib/user.nix
      ];
    };
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
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
}
