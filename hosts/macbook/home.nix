{ pkgs, sofka, ... }:

{
  imports = [
    ../../home/shell
    ../../home/apps/editors.nix
    sofka.homeManagerModules.default
    ./terminal.nix
    ./fish.nix
  ];

  home.username = "joel";
  home.homeDirectory = "/Users/joel";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    gh
    glab
    age
    sops
    yq-go
    kubectl
    kubectx
    kubernetes-helm
    k9s
    dyff
    eksctl
    fluxcd
    go-task
    pluto
    pre-commit
    pv
    stow
    tf-summarize
    tflint
    tfsec
    zellij
    uv
    bashInteractive
    ccache
    pkgconf
    resvg
    _7zz
    awscli2
    azure-cli
    granted
    gitlab-ci-ls
    nova
    docker-client
    lima
    minikube
    openssh
  ];

  xdg.enable = true;
  programs.home-manager.enable = true;


  programs.helix.settings.theme = "active";
  programs.sofka.enable = true;
  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig = {
      settings = {
        color_theme = "catppuccin";
        experimental = true;
      };
      tools = {
        go = "latest";
        python = "latest";
        pipx = "latest";
        bun = "latest";
        pnpm = "latest";
        zig = "latest";
        node = "latest";
        ruby = "latest";
        terraform = "latest";
        opentofu = "latest";
        vault = "latest";
        ansible = {
          version = "latest";
          # Ansible's CLI entry points are provided by its ansible-core dependency.
          uvx_args = "--with-executables-from ansible-core";
        };
        java = "temurin-21.0.10+7.0.LTS";
      };
    };
  };
}
