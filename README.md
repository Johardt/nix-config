# NixOS and macOS configuration

This repository manages the NixOS desktop `baremetal` and the macOS `macbook`.
The NixOS desktop uses Umbriel with Noctalia as its desktop shell and greeter,
with keyboard input and bindings intended to feel familiar to a macOS user.

### baremetal

- [Fresh installation with Disko](hosts/baremetal/INSTALL.md)
- [Disk layout](hosts/baremetal/disko.nix)

Rebuild the installed system with:

```bash
nh os switch
```

Evaluate the flake without building or switching:

```bash
nix flake check --no-build
```

### macbook

The macbook uses nix-darwin with integrated Home Manager. Git, Starship, bat,
Atuin, tmux, Fish, and shared CLI packages are managed here. Editors and other
dotfiles remain managed by chezmoi. Home Manager
imports are explicitly listed in `hosts/macbook/home.nix`.

Both hosts import `home/shell` for shared Fish, Git, terminal configuration, and
CLI packages. Host-specific packages and settings live in
`hosts/baremetal/home.nix` and the macbook home modules.

The upstream Nix installer bootstraps Nix; nix-darwin then manages the Nix
daemon and settings declaratively.

Fish retains `~/.config/fish/local.fish` for local overrides. The mise
installation remains unchanged during migration. After switching,
open a new terminal; `rebuild-macbook` provides a shorter rebuild command.

`hosts/macbook/homebrew.nix` declares all existing taps, explicitly installed
formulae, and casks for review. Homebrew resolves transitive dependencies. nix-homebrew manages the Homebrew installation
and migrates an existing prefix automatically; nix-darwin manages its packages and
Fish integration. Automatic upgrades and removal are disabled during migration.
Removing an entry prevents its installation on a new machine; it does not uninstall
an existing package until cleanup is enabled or it is explicitly uninstalled.
The Brew executable is pinned in the flake; formula and cask versions follow
Homebrew's repositories and API.

After installing Nix with flakes enabled, bootstrap or rebuild using the
repository's pinned nix-darwin executable:

```sh
sudo -H /nix/var/nix/profiles/default/bin/nix run \
  'path:/Users/joel/nix-config#darwin-rebuild' -- \
  switch --flake 'path:/Users/joel/nix-config#macbook'
```

After the first activation, rebuild directly with:

```sh
sudo -H /run/current-system/sw/bin/darwin-rebuild switch \
  --flake 'path:/Users/joel/nix-config#macbook'
```

Build without activating:

```sh
nix build 'path:/Users/joel/nix-config#darwinConfigurations.macbook.system'
```

The `path:` prefix includes new files before they are tracked by Git. Once
nix-darwin is activated, use its rebuild command for this machine's Home Manager
changes too.
