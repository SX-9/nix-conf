![image](https://github.com/user-attachments/assets/7f50aea9-ce0d-43d5-8907-d2c5eb7d9ac3)


```sh
# update hw config:
nixos-generate-config --show-hardware-config > hw-scan.nix

# installation
sudo nixos-rebuild switch --flake .#nixos

# using a thinkpad? (custom fan speeds, check hw-thinkpad.nix)
sudo nixos-rebuild switch --flake .#thinkpad
```
