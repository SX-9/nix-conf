{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, nixos-wsl, ... }: let
    hostname = "remote-workspace";
    username = "satr14";
    system = "x86_64-linux";

    git = {
      user = "satr14";
      email = "90962949+SX-9@users.noreply.github.com";
    };
  in {
    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username git; };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./home/main.nix
          ./home/laptop.nix
        ];
      };
      desktop = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username git; };
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
        extraSpecialArgs = { inherit username git; };
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
