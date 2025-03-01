{
  description = "satr14's nixos configuration";
  inputs = {
    ctp.url = "github:catppuccin/nix";
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wsl.url = "github:nix-community/NixOS-WSL/main";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ctp, nixpkgs, hm, wsl, ... }: let
    hostname = "nixos";
    username = "satr14";
    system = "x86_64-linux";

    git = {
      user = "satr14";
      email = "90962949+SX-9@users.noreply.github.com";
    };
  in {
    homeConfigurations = {
      laptop = hm.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username git; };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ctp.homeManagerModules.catppuccin
          ./home/main.nix
          ./home/laptop.nix
        ];
      };
      desktop = hm.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username git; };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ctp.homeManagerModules.catppuccin
          ./home/main.nix
          ./home/desktop.nix  
        ];
      };
      shell = hm.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username git; };
        pkgs = import nixpkgs { inherit system; };
        modules = [
          ctp.homeManagerModules.catppuccin
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
          wsl.nixosModules.wsl
        ];
      };
    };
  };
}
