![image](ss.png)


```sh
# 1. update hw config:
nixos-generate-config --show-hardware-config > hw/scan.nix

# 2. installation
sudo nixos-rebuild switch --flake .#nixos

# 2. using a thinkpad? (custom fan speeds, check hw/extras.nix)
sudo nixos-rebuild switch --flake .#thinkpad

# 3. gnome and zsh configuration
home-manager switch --flake .#main
```
