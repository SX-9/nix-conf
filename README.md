![image](ss.png)


```sh
# update hw config:
nixos-generate-config --show-hardware-config > hw/scan.nix

# installation
sudo nixos-rebuild switch --flake .#nixos

# using a thinkpad? (custom fan speeds, check hw/extras.nix)
sudo nixos-rebuild switch --flake .#thinkpad

# gnome and extensions configuration
home-manager switch --flake .#main
```
