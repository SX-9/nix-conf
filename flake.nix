{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, nixos-wsl, ... }: let
    hostname = "thinkpad-l450";
    username = "satr14";
    system = "x86_64-linux";
  in {
    homeConfigurations = {
      desktop = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username; };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./home/main.nix
          ./home/desktop.nix  
        ];
      };
      shell = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username; };
        pkgs = import nixpkgs { inherit system; };
        modules = [
          ./home/main.nix
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
          ./system/desktop
          ./system/desktop/user.nix
        ];
      };
      server = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
        };
        modules = [
          ./system/desktop
          ./system/desktop/user.nix
          ./hardware/server.nix
        ];
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
        };
        modules = [
          ./system/desktop
          ./system/desktop/user.nix
          ./hardware/extras.nix
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
          inherit system;
        };
        modules = [
          ./system/wsl
          ./system/wsl/user.nix
          nixos-wsl.nixosModules.wsl
        ];
      };
    };
  };
}
