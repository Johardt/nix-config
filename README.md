# NixOS and macOS configuration

This repository manages the NixOS desktop `baremetal` and the macOS `macbook`.
The NixOS desktop uses Umbriel with Noctalia as its desktop shell and greeter,
with keyboard input and bindings intended to feel familiar to a macOS user.

## baremetal

For a fresh install, follow the [Disko installation guide](hosts/baremetal/INSTALL.md)
to partition, encrypt, and install the system. Keep the configuration in
`/home/joel/nixos` on the installed machine, then rebuild with:

```sh
nh os switch
```

## macOS bootstrap

Install Nix with flakes enabled, clone to `/Users/joel/nix-config`, then run:

```sh
sudo -H /nix/var/nix/profiles/default/bin/nix run \
  'path:/Users/joel/nix-config#darwin-rebuild' -- \
  switch --flake 'path:/Users/joel/nix-config#macbook'
```

Open a new terminal after activation.

Macbook explicitly imports the development profile in `home/development.nix`,
which owns its development packages, shell helpers, and mise runtime versions.
Baremetal keeps its smaller development selection in `hosts/baremetal/home.nix`.

Install the global development tools declared in `home/development.nix`:

```sh
mise -C "$HOME" install
```

Home Manager installs mise and configures its Fish integration; mise downloads
the runtimes separately. Running from home avoids a project's mise configuration.

## Rebuild

```sh
nh os switch      # NixOS
nh darwin switch  # macOS
```

Both include Home Manager. Add `--update` to update flake inputs first.
Run nh without sudo; it elevates when needed. On macOS, `nh darwin build`
builds without activating.

## Updates outside Nix

`nh darwin switch --update` updates flake inputs and the Nix-managed packages,
including mise itself. Update mise's global tools separately:

```sh
mise -C "$HOME" upgrade
mise -C "$HOME" upgrade node  # Update only one tool
```

Most global tools use `latest`, so their resolved versions can change independently
of `flake.lock`. Java stays at its declared version. Edit tool declarations in
`home/development.nix`; avoid `mise use -g` and `mise upgrade --bump`, which try
to rewrite Home Manager's managed configuration. Project tool versions remain
controlled by each project's mise configuration.

To update Nix and the global mise tools together in Fish:

```fish
nh darwin switch --update; and mise -C "$HOME" upgrade
```

Tool downloads stay outside activation so a mise download failure does not fail
a system rebuild. Nix generation rollback does not roll back mise-installed tools.

Homebrew updates and upgrades are not automatic during activation. Update its
formulae and casks manually, including apps marked as auto-updating, with:

```sh
brew upgrade --greedy
```

Applications that provide their own updater can also be updated from the app.

## Local configuration and applications

Fish optionally loads `~/.config/fish/local.fish` after its managed integrations
for private or machine-local overrides. Keep shared shell settings in this
repository. Its PATH retains `~/.local/bin` (also exposed as `XDG_BIN_HOME`),
`~/.bun/bin` for globally installed Bun executables, and `~/.lmstudio/bin` for
the installed LM Studio app's CLI.

Home Manager manages Fish plugins directly through `programs.fish.plugins`;
Fisher is no longer needed. Autopair comes from nixpkgs. Fish's built-in
Catppuccin Macchiato theme uses Latte for light terminals and Macchiato for dark
terminals. Plugin and theme updates follow Nix updates.

Git includes the external `~/.gitconfig.local` for personal identity and signing
configuration (`user.name`, `user.email`, and `user.signingKey`). Create that file
locally on a new machine; it is intentionally kept outside this repository.

Neovim is installed through Home Manager and retains the local LazyVim
configuration and its plugin management. macOS Helix uses the built-in
`catppuccin_mocha` theme.

On baremetal, download the Linux Cider AppImage from your Cider download source
and save it as `~/Applications/Cider.AppImage`. Create `~/Applications` if needed;
the managed launcher opens that file. Cider handles updates from within the app,
separately from Nix rebuilds.

## Check

```sh
nix flake check --no-build
```
