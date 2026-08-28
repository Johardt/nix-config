{ pkgs, ... }:

{
  imports = [
    ./fish.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    btop
    codex
    curl
    fd
    gawk
    glow
    gnupg
    jq
    lazygit
    luarocks
    neovim
    nixd
    nixfmt
    ripgrep
    tree
    wget
  ];

  programs.bash.enable = true;

  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      style = "plain";
      theme = "noctalia";
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "noctalia";
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
}
