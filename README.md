![image](ss.png)


```nix
# 0. enable nix and git (add these lines to /etc/nixos/configuration.nix)
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.systemPackages = with pkgs; [ git vim ];
```

```sh
# 1. update hw config:
nixos-generate-config --show-hardware-config > hw/scan.nix

# 2. installation (pick a host)
sudo nixos-rebuild switch --flake .#nixos
sudo nixos-rebuild switch --flake .#thinkpad

# 3. gnome and zsh configuration
home-manager switch --flake .#main
```
