{ ... }:

{
  nix-homebrew = {
    enable = true;
    user = "joel";
    autoMigrate = true;
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    taps = [
      "alesbrelih/gitlab-ci-ls"
      "anomalyco/tap"
      { name = "boostsecurityio/tap"; trusted = true; }
      "catppuccin/tap"
      { name = "common-fate/granted"; trusted = true; }
      { name = "cormacrelf/tap"; trusted = true; }
      "fluxcd/tap"
      { name = "hashicorp/tap"; trusted = true; }
      "ionos-cloud/ionos-cloud"
      "minghinmatthewlam/tap"
      "nklmilojevic/sofka"
      "oven-sh/bun"
      { name = "stackitcloud/tap"; trusted = true; }
    ];

    # Explicitly installed formulae; Homebrew resolves their dependencies.
    brews = [
      "age"
      { name = "alesbrelih/gitlab-ci-ls/gitlab-ci-ls"; trusted = true; }
      { name = "anomalyco/tap/opencode-v2"; trusted = true; }
      "ansible"
      "ansible-lint"
      { name = "atuin"; restart_service = "changed"; }
      "aws-cdk"
      "awscli"
      "azure-cli"
      "bagel"
      "bash"
      "bat"
      "btop"
      "carapace"
      { name = "catppuccin/tap/whiskers"; trusted = true; }
      "ccache"
      "chezmoi"
      "common-fate/granted/granted"
      "container"
      "cormacrelf/tap/dark-notify"
      "direnv"
      "docker"
      "dyff"
      "eksctl"
      "eza"
      "fastfetch"
      "fd"
      "fish"
      { name = "fluxcd/tap/flux"; trusted = true; }
      "fzf"
      "gawk"
      "gh"
      "git"
      "git-crypt"
      "git-delta"
      "git-lfs"
      "glab"
      "glow"
      "gnupg"
      "go"
      "go-task"
      "gopass"
      "hashicorp/tap/terraform"
      "hashicorp/tap/vault"
      "helix"
      "helm"
      "jq"
      "k9s"
      "kubectx"
      "kubernetes-cli"
      "lazygit"
      "libfido2"
      "lima"
      "llvm"
      "luarocks"
      "minikube"
      "mise"
      "neovim"
      { name = "nklmilojevic/sofka/sofka"; trusted = true; }
      "nono"
      "nova-fairwinds"
      "ollama"
      "openssh"
      "opentofu"
      { name = "oven-sh/bun/bun"; trusted = true; }
      "pkgconf"
      "pluto"
      "pnpm"
      "pre-commit"
      "pv"
      "python@3.12"
      "python@3.13"
      "resvg"
      "ripgrep"
      "sevenzip"
      "sops"
      "starship"
      "stow"
      "tailwindcss"
      "tf-summarize"
      { name = "tfenv"; link = false; }
      "tflint"
      "tfsec"
      "tmux"
      "wget"
      "yq"
      "zellij"
      "zig"
      "zoxide"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
    ];

    casks = [
      "1password"
      "1password-cli@beta"
      "alcove"
      "atuin-desktop"
      "blender"
      "caskhub"
      "claude-code"
      "coderabbit"
      "container"
      "cursor"
      "firefox"
      "font-adwaita"
      "font-adwaita-mono-nerd-font"
      "font-caskaydia-mono-nerd-font"
      "font-geist-mono-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-maple-mono-nf"
      "font-symbols-only-nerd-font"
      "ghostty"
      "godot"
      "headlamp"
      "hyperkey"
      "inkscape"
      "linear"
      { name = "minghinmatthewlam/tap/pi-gui"; trusted = true; }
      "notion"
      "podman-desktop"
      "prismlauncher"
      "protonvpn"
      "raycast"
      "secretive"
      "session-manager-plugin"
      "slack"
      "stackitcloud/tap/stackit"
      "ungoogled-chromium"
      "unity-cli"
      "visual-studio-code"
      "zed"
      "zen"
      "zoom"
    ];
  };
}
