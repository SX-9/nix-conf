{
  description = "satr14's nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hm = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    win = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gl.url = "github:nix-community/nixGL";
    hl.url = "github:hyprwm/Hyprland";
    hw.url = "github:NixOS/nixos-hardware/master";
    na.url = "github:nix-community/nixos-anywhere";
    dsk.url = "github:nix-community/disko";
    ctp.url = "github:catppuccin/nix";
    dm.url = "github:Bqrry4/sddm-stray";
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
      overlays = [ inputs.gl.overlay ];
      config.allowUnfree = true;
    };

  in {
    nixosConfigurations = {

      nixos = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = args;
        modules = [ base.system ];
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

      main = inputs.hm.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = args;
        modules = [ base.home ];
      };

    };
  };
}
