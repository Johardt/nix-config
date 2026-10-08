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

  imports = [
    umbriel.homeModules.default
  ];

  # Umbriel activates this target after publishing its Wayland environment.
  # Graphical user services must follow the compositor session's lifetime.
  wayland.systemd.target = "umbriel-session.target";

  programs.umbriel = {
    enable = true;
    settings = {
      general = {
        autostart = [
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
        border_width = 2;
        corner_radius = 12;
        shadow = {
          enabled = true;
          softness = 12;
          offset_x = 0;
          offset_y = 3;
        };
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
      colors.shadow = "#00000060";

      # Noctalia regenerates this file whenever the palette changes. It is
      # included before the main config, so explicitly configured values below
      # continue to take precedence over theme values.
      include.files = [ "noctalia.toml" ];

      layout = {
        mode = "scrolling";
        gap = 12;
        # Bring tiled windows 8px closer to the bar while retaining the
        # existing spacing between windows and at the other output edges.
        struts.top = -8;
        scrolling = {
          default_extent_fraction = 0.5;
          center_underfull_strip = true;
        };
      };

      # Stable activity spaces; numeric bindings and rules select their positions.
      output."DP-1".workspaces = [
        "1 Browse"
        "2 Build"
        "3 Connect"
      ];

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

      # Command/navigation philosophy:
      # Command (Super) acts inside apps; Command+Space is the app launcher.
      # Caps navigates the desktop (Kanata emits Ctrl+Super, without Shift).
      # Left/right traverse windows; up/down traverse workspaces. Add Shift
      # to carry the focused column/window with you to the same destination.
      # Numbers select workspaces; Shift+numbers send the focused window there.
      # Caps+letters reach apps and desktop tools. Sizing uses separate keys.
      keybinds = {
        "Super+Space" = "spawn:noctalia msg panel-toggle launcher";
        "Super+Q" = "window-close";
        
        "Ctrl+Super+V" = {
          action = "spawn:noctalia msg panel-toggle clipboard";
          repeat = false;
        };
        "Ctrl+Super+F1" = "cheatsheet-toggle";
        "Ctrl+Super+Space" = "overview-toggle";

        # Scratchpad controls share the desktop modifier.
        "Ctrl+Super+Grave" = "scratchpad-toggle";
        "Ctrl+Shift+Super+Grave" = "window-toggle-scratchpad";
        "Ctrl+Super+Tab" = "scratchpad-focus-next";

        # Navigate the scrolling strip horizontally and workspaces vertically.
        "Ctrl+Super+Left" = "window-focus-left";
        "Ctrl+Super+Right" = "window-focus-right";
        "Ctrl+Super+Up" = "workspace-previous";
        "Ctrl+Super+Down" = "workspace-next";

        # Shift carries the column horizontally or the window between workspaces.
        "Ctrl+Shift+Super+Left" = "column-move-left";
        "Ctrl+Shift+Super+Right" = "column-move-right";
        "Ctrl+Shift+Super+Up" = "window-move-to-workspace-previous";
        "Ctrl+Shift+Super+Down" = "window-move-to-workspace-next";
        "Ctrl+Shift+Super+H" = "column-move-left";
        "Ctrl+Shift+Super+L" = "column-move-right";
        "Ctrl+Shift+Super+K" = "window-move-to-workspace-previous";
        "Ctrl+Shift+Super+J" = "window-move-to-workspace-next";

        # Presentation and width presets stay separate from directional movement.
        "Ctrl+Super+F" = "window-toggle-fullscreen";
        "Ctrl+Super+F10" = "window-set-primary-extent:0.5";
        "Ctrl+Super+F11" = "window-set-primary-extent:1";

        # Select a destination; add Shift to send the focused window there.
        "Ctrl+Super+1" = "workspace-switch:1";
        "Ctrl+Super+2" = "workspace-switch:2";
        "Ctrl+Super+3" = "workspace-switch:3";
        "Ctrl+Super+4" = "workspace-switch:4";
        "Ctrl+Super+5" = "workspace-switch:5";
        "Ctrl+Super+6" = "workspace-switch:6";
        "Ctrl+Super+7" = "workspace-switch:7";
        "Ctrl+Super+8" = "workspace-switch:8";
        "Ctrl+Super+9" = "workspace-switch:9";
        "Ctrl+Shift+Super+1" = "window-move-to-workspace:1";
        "Ctrl+Shift+Super+2" = "window-move-to-workspace:2";
        "Ctrl+Shift+Super+3" = "window-move-to-workspace:3";
        "Ctrl+Shift+Super+4" = "window-move-to-workspace:4";
        "Ctrl+Shift+Super+5" = "window-move-to-workspace:5";
        "Ctrl+Shift+Super+6" = "window-move-to-workspace:6";
        "Ctrl+Shift+Super+7" = "window-move-to-workspace:7";
        "Ctrl+Shift+Super+8" = "window-move-to-workspace:8";
        "Ctrl+Shift+Super+9" = "window-move-to-workspace:9";

        # Reach the existing app window, or launch it when absent.
        "Ctrl+Super+P" = {
          action = "spawn:umbriel-launch-or-focus '^(1password|1Password|com[.]1password[.]1Password)$' 1password";
          repeat = false;
        };
        "Ctrl+Super+Return" = {
          action = "spawn:umbriel-launch-or-focus '^com[.]mitchellh[.]ghostty$' ghostty";
          repeat = false;
        };
        "Ctrl+Super+B" = {
          action = "spawn:umbriel-launch-or-focus '^firefox$' firefox";
          repeat = false;
        };
        "Ctrl+Super+Z" = {
          action = "spawn:umbriel-launch-or-focus '^dev[.]zed[.]Zed$' zeditor";
          repeat = false;
        };
        "Ctrl+Super+E" = {
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
          default_floating_size = {
            width = 0.5;
            height = 0.625;
          };
        }
        {
          match.app_id = "^dev.noctalia.UmbrielSharePicker$";
          default_floating = true;
          default_floating_size = {
            width = 0.4;
            height = 0.42;
          };
          default_position = {
            x = 32;
            y = 32;
            anchor = "bottom_right";
          };
        }
        {
          match.app_id = "^(firefox|[Cc]ider|org[.]gnome[.]Nautilus)$";
          default_workspace = 1;
        }
        {
          # Connect: communication apps, including Chromium PWA IDs.
          match.app_id = "^(discord|chrome-mail[.]proton[.]me__u1_inbox-Default|chrome-web[.]whatsapp[.]com__-Default)$";
          default_workspace = 3;
        }
        {
          match.app_id = "^com[.]mitchellh[.]ghostty$";
          default_scrolling_extent = 0.5;
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
          match.namespace = ''^noctalia-(bar-[^"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^"]*)$'';
          blur = true;
          blur_ignore_alpha = 0.5;
          blur_optimized = false;
          blur_popups = true;
        }
      ];
    };
  };
}
