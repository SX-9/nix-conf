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
    # CHANE ME
    hostname = "nixos";
    username = "satr14";
    system = "x86_64-linux";
    legacy-boot = false; #true;

    git = {
      user = "satr14";
      email = "90962949+SX-9@users.noreply.github.com";
    };

    nixos-anywhere = {
      imports = [
        #### uncomment if building for remote nixos-anywhere machine and edit the disko configuration
        # dsk.nixosModules.disko
        # ./disko
      ];
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
    specialArgs = { inherit hostname username legacy-boot; };
    extraSpecialArgs = { inherit username git; };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  in {
    nixosConfigurations = {

      nixos = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [ base.system ];
      };

      server = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          base.system
          ./hardware/server.nix
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          base.system
          ./hardware/thinkpad.nix
        ];
      };

    };
    homeConfigurations = {

      shell = hm.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [ base.home ];
      };

      desktop = hm.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          base.home
          ./home/base.nix
        ];
      };

      server = hm.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          base.home
          ./home/server.nix
        ];
      };

      laptop = hm.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          base.home
          ./home/laptop.nix
        ];
      };

    };
  };
}
