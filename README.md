![image](ss.png)

```sh
# 0. clone repo and edit options:
nix-shell -p git vim
git clone github.com/SX-9/nix-conf --depth 1
vim flake.nix

# 1. hardware config:
nixos-generate-config --show-hardware-config > hardware/scan.nix
git add hardware/scan.nix -f

# 2. apply nixos config
sudo nixos-rebuild switch --flake .#nixos
sudo nixos-rebuild switch --flake .#server
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild switch --flake .#wsl

# 3. apply home config
home-manager switch --flake .#laptop
home-manager switch --flake .#desktop
home-manager switch --flake .#shell
```
