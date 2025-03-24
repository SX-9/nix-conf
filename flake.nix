{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    wsl.url = "github:nix-community/NixOS-WSL/main";
    na.url = "github:nix-community/nixos-anywhere";
    ctp.url = "github:catppuccin/nix";
  };

  outputs = { ctp, nixpkgs, hm, wsl, na, ... }: let
    hostname = "nixos";
    username = "satr14";
    system = "x86_64-linux";

    git = {
      user = "satr14";
      email = "90962949+SX-9@users.noreply.github.com";
    };

    nixos-anywhere = { environment.systemPackages = [ na.packages.x86_64-linux.default ]; };
  in {
    nixosConfigurations = {

      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
          lagacyBoot = false;
        };
        modules = [
          nixos-anywhere
          ./system/desktop
          ./system/desktop/user.nix
        ];
      };

      server = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
          legacyBoot = false;
        };
        modules = [
          nixos-anywhere
          ./system/desktop
          ./system/desktop/user.nix
          ./hardware/server.nix
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
          inherit username;
          legacyBoot = true;
        };
        modules = [
          nixos-anywhere
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
          nixos-anywhere
          wsl.nixosModules.wsl
          ./system/wsl
          ./system/wsl/user.nix
        ];
      };

    };
    homeConfigurations = {

      shell = hm.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit username git; };
        pkgs = import nixpkgs { inherit system; };
        modules = [
          ctp.homeManagerModules.catppuccin
          ./home/main.nix
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
          ./home/server.nix
        ];
      };

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

    };
  };
}
