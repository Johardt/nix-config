{
  pkgs,
  umbriel,
  ...
}:

let
  desktop = import ../shared/desktop.nix;
  launchOrFocus = pkgs.writeShellScriptBin "umbriel-launch-or-focus" ''
    set -eu

    if [ "$#" -lt 2 ]; then
      echo "usage: umbriel-launch-or-focus APP_ID_REGEX COMMAND [ARGUMENTS...]" >&2
      exit 2
    fi

    app_id_regex=$1
    shift
    window_id=$(
      umbriel windows --json |
        ${pkgs.jq}/bin/jq -r --arg app_id_regex "$app_id_regex" '
          [ .[] | select(.app_id | test($app_id_regex)) ]
          | sort_by(.focused)
          | reverse
          | .[0].id // empty
        '
    )

    if [ -n "$window_id" ]; then
      exec umbriel msg "window-focus:$window_id"
    fi

    exec "$@"
  '';
in
{
  home.packages = [ launchOrFocus ];

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
        # focus_on_activate = true;
      };

      appearance = {
        border_width = 4;
        corner_radius = 12;
        blur = {
          enabled = true;
          optimized = true;
          passes = 3;
          radius = 3;
          noise = 0.02;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.1;
        };
      };

      # Umbriel must take ownership of the display before Noctalia can create
      # its wallpaper layer. Use a dark color for that brief handoff instead
      # of the light palette's near-white default.
      colors.background = "#18252CFF";

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

      # Keep the numbered workspaces available so window rules can target
      # workspace 2 even when it is otherwise empty.
      output."DP-1".workspaces = 3;

      animation.scratchpad = {
        enabled = true;
        blur = true;
        dim = 0.35;
        scale = 0.7;
      };

      input = {
        keyboard = desktop.keyboard;
        touchpad.natural_scroll = true;
        cursor = desktop.cursor;
        focus = {
          follows_mouse = true;
          follows_mouse_max_scroll = 0.33;
        };
        middle_click_paste = false;
      };

      keybinds = {
        "Super+Space" = "spawn:noctalia msg panel-toggle launcher";
        "Super+Shift+V" = {
          action = "spawn:noctalia msg panel-toggle clipboard";
          repeat = false;
        };
        "Super+Shift+O" = "cheatsheet-toggle";
        "Super+O" = "overview-toggle";
        "Super+Q" = "window-close";

        # Keep frequently used windows nearby without dedicating a workspace.
        "Super+Grave" = "scratchpad-toggle";
        "Super+Shift+Grave" = "window-toggle-scratchpad";
        "Super+Tab" = "scratchpad-focus-next";

        "Super+Left" = "window-focus-left";
        "Super+Down" = "window-focus-down";
        "Super+Up" = "window-focus-up";
        "Super+Right" = "window-focus-right";
        "Super+H" = "window-focus-left";
        "Super+J" = "window-focus-down";
        "Super+K" = "window-focus-up";
        "Super+L" = "window-focus-right";
        # Keep Super+F available for application-level Find, as on macOS.

        # Column / Window altering commands (Shift+Super)
        "Shift+Super+F" = "window-toggle-maximize-to-edges";
        "Shift+Super+Up" = "window-set-width:1";
        "Shift+Super+Down" = "window-set-width:0.5";
        "Shift+Super+Left" = "column-move-left";
        "Shift+Super+Right" = "column-move-right";

        # Workspace-control commands (Hyper)
        "Ctrl+Shift+Super+Down" = "workspace-next";
        "Ctrl+Shift+Super+Up" = "workspace-previous";
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
          action = "spawn:umbriel-launch-or-focus '^(1password|1Password|com[.]1password[.]1Password)$' 1password";
          repeat = false;
        };
        "Ctrl+Shift+Super+Return" = {
          action = "spawn:umbriel-launch-or-focus '^com[.]mitchellh[.]ghostty$' ghostty";
          repeat = false;
        };
        "Ctrl+Shift+Super+B" = {
          action = "spawn:umbriel-launch-or-focus '^firefox$' firefox";
          repeat = false;
        };
        "Ctrl+Shift+Super+Z" = {
          action = "spawn:umbriel-launch-or-focus '^dev[.]zed[.]Zed$' zeditor";
          repeat = false;
        };
        "Ctrl+Shift+Super+E" = {
          action = "spawn:umbriel-launch-or-focus '^org[.]gnome[.]Nautilus$' nautilus";
          repeat = false;
        };

        "Print" = "spawn:noctalia msg screenshot-region";
      };

      window_rule = [
        {
          # Noctalia's translucent windows should reveal a blurred backdrop.
          blur = true;
          blur_optimized = true;
        }
        {
          match.app_id = "^dev.noctalia.Noctalia$";
          default_floating = true;
          default_width = 0.5;
          default_height = 0.625;
        }
        {
          match.app_id = "^dev.noctalia.UmbrielSharePicker$";
          default_floating = true;
          default_width = 0.4;
          default_height = 0.42;
          default_position = {
            x = 32;
            y = 32;
            anchor = "bottom_right";
          };
        }
        {
          match.app_id = "^firefox$";
          default_workspace = 1;
        }
        {
          match.app_id = "^com[.]mitchellh[.]ghostty$";
          default_workspace = 2;
        }
        {
          match.app_id = "^dev[.]zed[.]Zed$";
          default_workspace = 2;
        }
        {
          # Prefer semantic hints supplied by native clients and Proton over
          # brittle title or application-name matching.
          match.content_type = "game";
          default_fullscreen = true;
          vrr = "always";
          tearing = true;
          hdr = "fullscreen";
        }
      ];

      layer_rule = [
        {
          match.namespace = ''^noctalia-(bar-[^"]+|notification|dock|panel|attached-panel|osd)$'';
          blur = true;
          blur_ignore_alpha = 0.5;
          blur_optimized = false;
        }
      ];
    };
  };
}
