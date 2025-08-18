{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hl.url = "github:hyprwm/Hyprland";
    hlp = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hl";
    };

    qs = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hw.url = "github:NixOS/nixos-hardware/master";
    na.url = "github:nix-community/nixos-anywhere";
    dsk.url = "github:nix-community/disko";
    ctp.url = "github:catppuccin/nix";

    dm.url = "github:Bqrry4/sddm-stray"; # cool theme
  };

  outputs = inputs: let
    info = import ./options.nix;
    args = {
      inherit inputs;
    } // info;

    nixos-anywhere = {
      imports = if info.partition then [
        inputs.dsk.nixosModules.disko
        ./disko
      ] else [];
      environment.systemPackages = [ inputs.na.packages.x86_64-linux.default ];
    };

    base = {
      system.imports = [
        nixos-anywhere
        ./system
        ./system/user.nix
      ];
      home.imports = [
        inputs.ctp.homeModules.catppuccin
        ./home/main.nix
      ];
    };
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };

  in {
    nixosConfigurations = {

      nixos = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = args;
        modules = [ base.system ];
      };

      server = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = args;
        modules = [
          base.system
          ./hardware/server.nix
        ];
      };

      thinkpad = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = args;
        modules = [
          base.system
          inputs.hw.nixosModules.lenovo-thinkpad-t480
          ./hardware/thinkpad.nix
        ];
      };

    };
    homeConfigurations = {

      shell = inputs.hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = args;
        modules = [ base.home ];
      };

      desktop = inputs.hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = args;
        modules = [
          base.home
          ./home/base.nix
        ];
      };

      server = inputs.hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = args;
        modules = [
          base.home
          ./home/server.nix
        ];
      };

      laptop = inputs.hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = args;
        modules = [
          base.home
          ./home/laptop.nix
        ];
      };

    };
  };
}
