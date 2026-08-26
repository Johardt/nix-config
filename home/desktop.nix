{
  pkgs,
  noctalia,
  umbriel,
  ...
}:

{
  imports = [
    noctalia.homeModules.default
    umbriel.homeModules.default
  ];

  home.packages = [
    pkgs.prismlauncher
  ];

  programs.noctalia.enable = true;

  programs.umbriel = {
    enable = true;
    settings = {
      general = {
        autostart = [ "noctalia" ];
        mod_key = "Super";
        xwayland = true;
        show_cheatsheet = false;
      };

      appearance = {
        border_width = 4;
        border_focused = "#7fc8ffff";
        border_unfocused = "#505050ff";
        corner_radius = 12;
        animation_ms = 150;
      };

      layout = {
        mode = "scrolling";
        gap = 12;
        scrolling.center_underfull_strip = true;
      };

      input = {
        keyboard = {
          layout = "de";
          variant = "mac_nodeadkeys";
          options = "lv3:alt_switch";
        };
        touchpad.natural_scroll = true;
        cursor = {
          theme = "Bibata-Modern-Classic";
          size = 24;
        };
        focus = {
          follows_mouse = true;
          follows_mouse_max_scroll = 0.33;
        };
      };

      keybinds = {
        "Ctrl+Alt+Shift+Super+Space" = "spawn:noctalia msg panel-toggle launcher";
        "Super+Shift+O" = "cheatsheet-toggle";
        "Super+Q" = "window-close";

        "Super+Left" = "window-focus-left";
        "Super+Down" = "window-focus-down";
        "Super+Up" = "window-focus-up";
        "Super+Right" = "window-focus-right";
        "Super+H" = "window-focus-left";
        "Super+J" = "window-focus-down";
        "Super+K" = "window-focus-up";
        "Super+L" = "window-focus-right";
        "Super+F" = "window-toggle-maximize-to-edges";

        "Ctrl+Alt+Shift+Super+1" = "workspace-switch:1";
        "Ctrl+Alt+Shift+Super+2" = "workspace-switch:2";
        "Ctrl+Alt+Shift+Super+3" = "workspace-switch:3";
        "Ctrl+Alt+Shift+Super+4" = "workspace-switch:4";
        "Ctrl+Alt+Shift+Super+5" = "workspace-switch:5";
        "Ctrl+Alt+Shift+Super+6" = "workspace-switch:6";
        "Ctrl+Alt+Shift+Super+7" = "workspace-switch:7";
        "Ctrl+Alt+Shift+Super+8" = "workspace-switch:8";
        "Ctrl+Alt+Shift+Super+9" = "workspace-switch:9";

        # Hyper already contains Shift, so F1-F9 provide a distinct set for
        # moving the focused window while the number row switches workspaces.
        "Ctrl+Alt+Shift+Super+F1" = "window-move-to-workspace:1";
        "Ctrl+Alt+Shift+Super+F2" = "window-move-to-workspace:2";
        "Ctrl+Alt+Shift+Super+F3" = "window-move-to-workspace:3";
        "Ctrl+Alt+Shift+Super+F4" = "window-move-to-workspace:4";
        "Ctrl+Alt+Shift+Super+F5" = "window-move-to-workspace:5";
        "Ctrl+Alt+Shift+Super+F6" = "window-move-to-workspace:6";
        "Ctrl+Alt+Shift+Super+F7" = "window-move-to-workspace:7";
        "Ctrl+Alt+Shift+Super+F8" = "window-move-to-workspace:8";
        "Ctrl+Alt+Shift+Super+F9" = "window-move-to-workspace:9";

        "Ctrl+Alt+Shift+Super+P" = {
          action = "spawn:1password";
          repeat = false;
        };
        "Ctrl+Alt+Shift+Super+T" = {
          action = "spawn:ghostty";
          repeat = false;
        };
        "Ctrl+Alt+Shift+Super+B" = {
          action = "spawn:firefox";
          repeat = false;
        };
        "Ctrl+Alt+Shift+Super+E" = {
          action = "spawn:nautilus";
          repeat = false;
        };

        "Print" = "spawn:noctalia msg screenshot-region";
      };
    };
  };
}
