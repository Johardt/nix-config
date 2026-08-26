{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    eza
  ];

  home.sessionVariables = {
    EDITOR = "zed --wait";
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";
    GOPATH = "${config.xdg.dataHome}/go";
    GOBIN = "${config.home.homeDirectory}/.local/bin";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";

    CLICOLOR = "1";
    LS_COLORS = "di=1;34:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43";

    FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    FZF_ALT_C_COMMAND = "fd --type d --strip-cwd-prefix --hidden --follow --exclude .git";
  };

  home.sessionPath = [
    "$HOME/.lmstudio/bin"
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
  ];

  programs = {
    atuin = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        filter_mode_shell_up_key_binding = "directory";
        style = "compact";
        enter_accept = false;
        sync.records = true;
        search.disable_up_key = true;
        ai.enabled = false;
      };
    };

    fish = {
      enable = true;

      shellAliases = {
        vi = "nvim";
        lg = "lazygit";
        wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";

        gs = "git status --short";
        gd = "git diff";
        gap = "git add --patch";
        gl = "git gl";
        gcm = "git commit -m";
        gco = "git checkout";

        ls = "eza --color=always --group-directories-first --icons";
        ll = "eza -la --color=always --group-directories-first --icons";
        la = "eza -a --color=always --group-directories-first --icons";
        lt = "eza -T --color=always --group-directories-first --icons";
        lh = "eza -la --color=always --group-directories-first --icons";
        cat = "bat --paging=never";

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        reload = "exec fish";
      };

      interactiveShellInit = ''
        set -g fish_greeting
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -gx FZF_DEFAULT_OPTS '
          --height 40%
          --layout=reverse
          --border=rounded
          --preview "bat --color=always --style=numbers --line-range=:500 {}"
          --preview-window=right:60%:wrap
          --bind="ctrl-u:preview-page-up,ctrl-d:preview-page-down"
        '
        set -gx FZF_CTRL_T_OPTS "$FZF_DEFAULT_OPTS
          --preview \"bat -n --color=always {}\"
          --bind \"ctrl-/:change-preview-window(down|hidden|)\"
        "

        fish_vi_key_bindings
        set -g fish_sequence_key_delay_ms 10

        set -l local_config "$XDG_CONFIG_HOME/fish/local.fish"
        if test -f "$local_config"
          source "$local_config"
        end
      '';

      functions = {
        fish_user_key_bindings = ''
          fish_vi_key_bindings
          bind --mode insert \ca beginning-of-line
          bind --mode insert \ce end-of-line
          bind --mode insert \ck kill-line
          bind --mode insert \cu kill-whole-line
          bind --mode insert \cw backward-kill-word
          bind --mode insert \cy yank
          bind --mode insert \cp up-line
          bind --mode insert \cn down-line
          bind --mode insert \eb backward-word
          bind --mode insert \ef forward-word
          bind --mode insert \cl clear-screen
          bind --mode insert ctrl-space accept-autosuggestion
        '';

        cx = ''
          if test (count $argv) -eq 0
            cd ~
          else if test (count $argv) -eq 1
            cd "$argv[1]"
          else
            echo "Usage: cx [dir]"
            return 1
          end

          if test $status -eq 0
            eza --color=always --group-directories-first --icons
          end
        '';

        git-prune-branches = {
          description = "Delete local branches whose upstream no longer exists";
          body = ''
            git rev-parse --is-inside-work-tree >/dev/null 2>&1
            or begin
              echo "Not a git repository"
              return 1
            end

            git fetch --prune
            or return

            set -l branches
            for branch in (git for-each-ref --format='%(refname:short)|%(upstream:track)' refs/heads)
              set -l fields (string split -m 1 '|' -- $branch)
              if test "$fields[2]" = '[gone]'
                set -a branches $fields[1]
              end
            end

            if test (count $branches) -eq 0
              echo "No local branches have a deleted upstream"
              return
            end

            echo "The following local branches will be deleted:"
            printf '  %s\n' $branches
            read --prompt-str="Delete these branches? [y/N] " --nchars=1 confirmation

            if not string match -qir '^y$' -- $confirmation
              echo "Cancelled"
              return
            end

            git branch -D -- $branches
          '';
        };

        gitlog = ''
          git rev-parse --is-inside-work-tree >/dev/null 2>&1
          or begin
            echo "Not a git repository"
            return 1
          end

          git --no-pager log --oneline --color=always | fzf --ansi --preview 'git --no-pager show --color=always {1}'
        '';
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    mise = {
      enable = true;
      enableFishIntegration = true;
      globalConfig.settings.color_theme = "catppuccin";
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };

  # Atuin creates a regular default config on first launch. Home Manager owns
  # this path now; account state, encryption keys, and history live elsewhere.
  xdg.configFile."atuin/config.toml".force = pkgs.lib.mkForce true;
}
