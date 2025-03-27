{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    na.url = "github:nix-community/nixos-anywhere";
    dsk.url = "github:nix-community/disko";
    ctp.url = "github:catppuccin/nix";
  };

  outputs = { ctp, nixpkgs, hm, na, dsk, ... }: let
    info = import ./info.nix;

    nixos-anywhere = {
      imports = if info.partition then [
        dsk.nixosModules.disko
        ./disko
      ] else [];
      environment.systemPackages = [ na.packages.x86_64-linux.default ];
    };

    base = {
      system.imports = [
        nixos-anywhere
        ./system
        ./system/user.nix
      ];
      home.imports = [
        ctp.homeManagerModules.catppuccin
        ./home/main.nix
      ];
    };
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };

  in {
    nixosConfigurations = {

      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = info;
        modules = [ base.system ];
      };

      server = nixpkgs.lib.nixosSystem {
        specialArgs = info;
        modules = [
          base.system
          ./hardware/server.nix
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = info;
        modules = [
          base.system
          ./hardware/thinkpad.nix
        ];
      };

    };
    homeConfigurations = {

      shell = hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = info;
        modules = [ base.home ];
      };

      desktop = hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = info;
        modules = [
          base.home
          ./home/base.nix
        ];
      };

      server = hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = info;
        modules = [
          base.home
          ./home/server.nix
        ];
      };

      laptop = hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = info;
        modules = [
          base.home
          ./home/laptop.nix
        ];
      };

    };
  };
}
