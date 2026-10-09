{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      right_format = "";
      format = "$all$fill$terraform$kubernetes$aws\n$shell$character\n";
      fill.symbol = " ";
      line_break.disabled = true;
      aws.symbol = " ";
      git_status.format = "([$all_status$ahead_behind]($style) )";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      style = "plain";
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

    fzf = {
      enable = true;
      enableFishIntegration = true;
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
}
