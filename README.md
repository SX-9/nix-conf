![image](ss.png)


```nix
# 0. initial /etc/nixos/configuration.nix:
{ pkgs, ... }: {
    system.stateVersion = "24.05";
    environment.systemPackages = with pkgs; [ git vim ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    # ... other options ...
}
```

```sh
# 1. hardware config:
nixos-generate-config --show-hardware-config > hw/scan.nix

# 2. nixos config
sudo nixos-rebuild switch --flake .#nixos
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild switch --flake .#wsl

# 3. home-manager config
home-manager switch --flake .#desktop
home-manager switch --flake .#shell
```
