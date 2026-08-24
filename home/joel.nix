{ config, pkgs, ... }:

let
  catppuccinBat = variant: pkgs.catppuccin.override {
    inherit variant;
    themeList = [ "bat" ];
  };
in

{
  imports = [
    ./desktop.nix
    ./fish.nix
    ./gnome.nix
  ];

  home.username = "joel";
  home.homeDirectory = "/home/joel";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    atuin-desktop
    btop
    codex
    curl
    delta
    gawk
    git-crypt
    git-lfs
    glow
    gnupg
    lazygit
    luarocks
    neovim
    fd
    jq
    podman-desktop
    ripgrep
    tree
    wget
  ];

  programs.atuin.settings = {
    filter_mode_shell_up_key_binding = "directory";
    style = "compact";
    enter_accept = false;
    sync.records = true;
    search.disable_up_key = true;
    ai.enabled = false;
  };

  # Atuin creates a regular default config on first launch. Home Manager owns
  # this path now; account state, encryption keys, and history live elsewhere.
  xdg.configFile."atuin/config.toml".force = pkgs.lib.mkForce true;

  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      style = "plain";
      theme = "auto:system";
      theme-dark = "Catppuccin Macchiato";
      theme-light = "Catppuccin Latte";
    };
    themes = {
      "Catppuccin Latte".src = "${catppuccinBat "latte"}/bat";
      "Catppuccin Macchiato".src = "${catppuccinBat "macchiato"}/bat";
    };
  };

  programs.mise.globalConfig.settings.color_theme = "catppuccin";

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_macchiato";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = "set -g @catppuccin_flavor 'latte'";
      }
    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set -g status-left ""
      set -g status-right '#[fg=#{@thm_crust},bg=#{@thm_teal}] session: #S '
      set -g status-right-length 100
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      core = {
        compression = 9;
        whitespace = "error";
        preloadindex = true;
        pager = "delta";
        excludesFile = "~/.config/git/gitignore";
      };

      gpg = {
        format = "ssh";
        ssh = {
          program = "/run/current-system/sw/bin/op-ssh-sign";
          allowedSignersFile = "~/.config/git/gitallowedsigners";
        };
      };

      commit.gpgsign = true;
      include.path = "~/.gitconfig.local";
      init.defaultBranch = "main";

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };

      diff = {
        context = 3;
        renames = "copies";
        interHunkContext = 10;
        renameLimit = 99999;
      };

      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        syntax-theme = "GitHub";
        line-numbers = true;
        hunk-header-decoration-style = "none";
      };

      push = {
        autoSetupRemote = true;
        default = "simple";
      };

      pull = {
        rebase = true;
        ff = "only";
      };

      rebase = {
        autoStash = true;
        missingCommitsCheck = "warn";
      };

      merge.conflictstyle = "zdiff3";
      log.abbrevCommit = true;
      branch.sort = "-committerdate";
      tag.sort = "-taggerdate";
      pager = {
        branch = false;
        tag = false;
      };

      alias = {
        gl = "log --all --graph --decorate --pretty=format:'%C(auto)%h %an %ar%C(auto) %D%n%s%n'";
        cleanup = "!git fetch --prune && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d";
      };

      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };

      user.pronouns = "he/him";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };

  programs.bash.enable = true;

  programs.zed-editor = {
    enable = true;
    userSettings = builtins.fromJSON (builtins.readFile ./zed-settings.json);
  };

  xdg.configFile."ghostty/config".source = ./ghostty.conf;

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "CLI"
  '';

  xdg.configFile."git/gitignore".text = ''
    # IDEs
    .zed/

    # macOS
    .DS_Store

    # Environment files
    .env
    .env.*

    .codex/
  '';

  xdg.configFile."git/gitallowedsigners".text = ''
    johardt@proton.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQu1Z+fglMZyLVa8g5ljGAgC4SE0+jJPZLunoNfOt5m
  '';

  programs.home-manager.enable = true;
}
