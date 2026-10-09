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
Atuin, tmux, Fish, Carapace, Helix, Neovim, and CLI packages are managed here.
Helix shares editor settings with baremetal and retains its active macOS theme.
Neovim retains its existing local LazyVim configuration. Zed and Ghostty remain
installed through Homebrew casks; Home Manager manages their settings through
`home/apps/zed.nix` and `home/apps/ghostty.nix`, shared with NixOS. Zed settings
and keymaps live together in `home/apps/zed.nix`, with explicit platform overrides.
On macOS, settings and keymaps are read-only and should
be edited here. Existing files are backed up with `.before-home-manager` on first
activation. Remove the corresponding chezmoi source ownership before applying
chezmoi again, so it does not overwrite Home Manager configuration.
Sofka uses its upstream flake and
Home Manager module. Imports are explicitly listed in `hosts/macbook/home.nix`.

Mac fonts are declared in `hosts/macbook/default.nix` through nix-darwin
`fonts.packages`, which installs them in `/Library/Fonts/Nix Fonts`. The next
rebuild removes their former Homebrew casks and installs the Nix-managed fonts;
restart applications afterward if they retain cached font lists.

Both hosts import `home/shell` for shared Fish, Git, terminal configuration, and
CLI packages. Host-specific packages and settings live in
`hosts/baremetal/home.nix` and the macbook home modules.

The upstream Nix installer bootstraps Nix; nix-darwin then manages the Nix
daemon and settings declaratively.

Fish retains `~/.config/fish/local.fish` for local overrides. Home Manager installs
mise and initializes it in Fish. Global Go, Python, Bun, pnpm, Zig, Node, Ruby, Terraform, OpenTofu,
Vault, Ansible, and ansible-lint versions are declared as `latest` in `hosts/macbook/home.nix`; Java retains its
existing Temurin 21 default. Run `mise install` after activation to install tools,
and `mise upgrade <tool>` to refresh a selected tool. Project mise configs can
select other versions. Nix supplies uv for mise’s isolated Ansible
and ansible-lint installations. After switching,
open a new terminal. Home Manager installs nh and sets `NH_DARWIN_FLAKE` to this
repository's macbook configuration, including untracked files through the `path:`
reference. Run `nh darwin switch` to rebuild, or `nh darwin switch --update` to
update all flake inputs first. Run nh as your user; it elevates for activation.
The update flag changes `flake.lock`; it does not upgrade Homebrew casks or mise
tools. The former `rebuild-macbook` Fish function has been removed.

`hosts/macbook/homebrew.nix` declares native app casks and the remaining Brew
exceptions: OpenCode, bagel, Apple Container, dark-notify, nono, and Ollama.
Homebrew resolves transitive dependencies. nix-homebrew manages the installation
and migrates an existing prefix automatically; nix-darwin manages its packages and
Fish integration. Automatic updates and upgrades are disabled. Activation cleanup
is enabled: removing a declared formula or cask uninstalls it on the next rebuild.
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
