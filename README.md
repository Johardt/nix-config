# NixOS bootstrap

Install NixOS normally, creating the user `joel`. Then, from the installed system:

```bash
# Put this repo in its non-standard location (copy it here or clone it).
mkdir -p /home/joel/nixos
# git clone <repo-url> /home/joel/nixos
sudo chown -R joel:users /home/joel/nixos

# Keep the hardware config generated for this machine.
sudo cp /etc/nixos/hardware-configuration.nix /home/joel/nixos/hosts/baremetal/

# Bootstrap the flake directly; nh is installed by this switch.
sudo nixos-rebuild switch \
  --extra-experimental-features 'nix-command flakes' \
  --flake /home/joel/nixos#baremetal
```

After that, rebuild with:

```bash
nh os switch
```

The flake path is configured in `programs.nh.flake`; `/etc/nixos` is not used after bootstrap. This config expects the username `joel`, hostname `baremetal`, x86-64/UEFI, and NVIDIA hardware—adjust those bits before the first rebuild if the new machine differs.
