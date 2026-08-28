{
  pkgs,
  umbriel,
  ...
}:

let
  desktop = import ../shared/desktop.nix;
in
{
  # Umbriel and its shell are intentionally isolated from shared desktop and
  # GNOME configuration.
  imports = [
    umbriel.homeModules.default
  ];

  # GNOME starts IBus through its session target. In Umbriel, replace the
  # generic XIM autostart entry with IBus's Wayland UI, which owns the daemon.
  xdg.configFile."autostart/ibus-daemon.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=IBus
    Exec=${pkgs.ibus}/libexec/ibus-ui-gtk3 --enable-wayland-im --exec-daemon --daemon-args "--xim --panel disable"
    OnlyShowIn=umbriel;
  '';

  programs.umbriel = {
    enable = true;
    settings = {
      general = {
        autostart = [
          "noctalia"
          # Keep the app and SSH agent available without opening the locked
          # main window immediately after login.
          "1password --silent"
        ];
        mod_key = "Super";
        xwayland = true;
        show_cheatsheet = false;
      };

      appearance = {
        border_width = 4;
        corner_radius = 12;
      };

      # Noctalia regenerates this file whenever the palette changes. It is
      # included before the main config, so explicitly configured values below
      # continue to take precedence over theme values.
      include.files = [ "noctalia.toml" ];

      layout = {
        mode = "scrolling";
        gap = 12;
        scrolling = {
          center_underfull_strip = true;
          default_width_fraction = 0.5;
        };
      };

      input = {
        keyboard = desktop.keyboard;
        touchpad.natural_scroll = true;
        cursor = desktop.cursor;
        focus = {
          follows_mouse = true;
          follows_mouse_max_scroll = 0.33;
        };
      };

      keybinds = {
        "Super+Space" = "spawn:noctalia msg panel-toggle launcher";
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

        "Ctrl+Shift+Super+1" = "workspace-switch:1";
        "Ctrl+Shift+Super+2" = "workspace-switch:2";
        "Ctrl+Shift+Super+3" = "workspace-switch:3";
        "Ctrl+Shift+Super+4" = "workspace-switch:4";
        "Ctrl+Shift+Super+5" = "workspace-switch:5";
        "Ctrl+Shift+Super+6" = "workspace-switch:6";
        "Ctrl+Shift+Super+7" = "workspace-switch:7";
        "Ctrl+Shift+Super+8" = "workspace-switch:8";
        "Ctrl+Shift+Super+9" = "workspace-switch:9";

        # Hyper already contains Shift, so F1-F9 provide a distinct set for
        # moving the focused window while the number row switches workspaces.
        "Ctrl+Shift+Super+F1" = "window-move-to-workspace:1";
        "Ctrl+Shift+Super+F2" = "window-move-to-workspace:2";
        "Ctrl+Shift+Super+F3" = "window-move-to-workspace:3";
        "Ctrl+Shift+Super+F4" = "window-move-to-workspace:4";
        "Ctrl+Shift+Super+F5" = "window-move-to-workspace:5";
        "Ctrl+Shift+Super+F6" = "window-move-to-workspace:6";
        "Ctrl+Shift+Super+F7" = "window-move-to-workspace:7";
        "Ctrl+Shift+Super+F8" = "window-move-to-workspace:8";
        "Ctrl+Shift+Super+F9" = "window-move-to-workspace:9";

        "Ctrl+Shift+Super+P" = {
          action = "spawn:1password";
          repeat = false;
        };
        "Ctrl+Shift+Super+T" = {
          action = "spawn:ghostty";
          repeat = false;
        };
        "Ctrl+Shift+Super+B" = {
          action = "spawn:firefox";
          repeat = false;
        };
        "Ctrl+Shift+Super+Z" = {
          action = "spawn:zed";
          repeat = false;
        };
        "Ctrl+Shift+Super+E" = {
          action = "spawn:nautilus";
          repeat = false;
        };

        "Print" = "spawn:noctalia msg screenshot-region";
      };
    };
  };
}
