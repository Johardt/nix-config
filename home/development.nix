{ config, pkgs, ... }:

{
  # Opt-in cloud, infrastructure, and application development profile.
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

  home.sessionVariables = {
    NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
    ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
    AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
    AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };

  programs.fish = {
    shellAliases = {
      kc = "kubectl";
      kx = "kubectx";
      tf = "terraform";
    };

    functions = {
      assume = ''
        source ${pkgs.granted}/share/assume.fish $argv
      '';
      kcfg = ''
        kubeconfig-load $argv
      '';
      kubeconfig-load = ''
        set -l configs ~/.kube/*.yml ~/.kube/*.yaml
        set -l kubeconfigs
        for config in $configs
          if test -f "$config"
            set --append kubeconfigs "$config"
          end
        end
        set -gx KUBECONFIG (string join : $kubeconfigs)
        kubectx
      '';
      kunset = ''
        set -gx KUBECONFIG /dev/null
        echo "KUBECONFIG disabled"
      '';
    };
  };

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
