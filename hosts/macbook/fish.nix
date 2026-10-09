{ config, lib, ... }:

{
  programs.man.generateCaches = false;

  home.sessionVariables = {
    HOMEBREW_NO_ENV_HINTS = "1";
    SHELL_SESSIONS_DISABLE = "1";
    XDG_RUNTIME_DIR = "${config.home.homeDirectory}/.local/run";
    NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
    ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
    AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
    AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };

  programs.fish = {
    # nix-darwin initializes Homebrew; prefer Nix tools over Brew duplicates.
    shellInit = lib.mkBefore ''
      fish_add_path --move --path "$HOME/.nix-profile/bin" /run/current-system/sw/bin
    '';

    interactiveShellInit = ''
      if command -q mise
        mise activate fish | source
      end
    '';

    shellAliases = {
      cm = "chezmoi";
      oc = "opencode";
      pw = "packwiz";
      kc = "kubectl";
      kx = "kubectx";
      tf = "terraform";
    };

    functions = {
      assume = ''
        source (command -s assume.fish) $argv
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
      rebuild-macbook = ''
        sudo -H /run/current-system/sw/bin/darwin-rebuild switch \
          --flake 'path:/Users/joel/nix-config#macbook' $argv
      '';
    };
  };

  # Replace chezmoi's old startup fragments to prevent duplicate initialization.
  xdg.configFile."fish/conf.d/00-env.fish".text = "# Environment is managed in config.fish by Home Manager.\n";
  xdg.configFile."fish/conf.d/aliases.fish".text = "# Aliases are managed in config.fish by Home Manager.\n";
  xdg.configFile."fish/conf.d/keybinds.fish".text = "# Keybindings are managed by Home Manager.\n";
}
