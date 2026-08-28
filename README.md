# NixOS configuration

This repository defines my very personalized and opinionated nixos configuration, focused around feeling native for a macOS user.  
This means keybinds and keyboard input assume a macOS user on a macOS keyboard.  
It also uses the new and experimental Umbriel WM, but keeps a nicely configured GNOME session installed as backup.

### Installation

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
