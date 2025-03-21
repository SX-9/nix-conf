![image](ss.png)

> [!WARNING]
> While the system when built and configured uses less than 4GB of memory, **building it for the first time requires 12GB of memory** so its recomended you create a swapfile or add more memory first if you dont have sufficient memory. Otherwise the system will crash while building from out of memory.

```sh
# 0. clone repo and edit options:
nix-shell -p git vim tmux htop home-manager
git clone github.com/SX-9/nix-conf --depth 1
vim flake.nix # change the username and hostname here

# 1. hardware config:
nixos-generate-config --show-hardware-config > hardware/scan.nix
git add . -f

# 2. apply nixos config (available flakes: nixos, server, thinkpad, wsl)
sudo nixos-rebuild switch --flake .#nixos

# 3. apply home config (available flakes: shell, desktop, laptop)
home-manager switch --flake .#shell
```
