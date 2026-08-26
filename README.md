# NixOS configuration

This repository defines the NixOS host `baremetal` and its Home Manager
configuration.

- [Fresh installation with Disko](hosts/baremetal/INSTALL.md)
- [Disk layout](hosts/baremetal/disko.nix)

Rebuild the installed system with:

```bash
nh os switch
```

Validate the complete configuration without switching:

```bash
nix flake check --no-build
```
