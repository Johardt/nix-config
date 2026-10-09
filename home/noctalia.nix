{
  config,
  mainMonitor,
  noctalia,
  pkgs-unstable,
  ...
}:

{
  imports = [ noctalia.homeModules.default ];

  systemd.user.services.noctalia = {
    # Stop immediately if the compositor exits, including an unexpected crash.
    Unit.BindsTo = [ "umbriel.service" ];
    Service.RestartSec = 3;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    # Noctalia v5 from nixpkgs-unstable. This is intentionally `noctalia`,
    # not the legacy Quickshell-based `noctalia-shell` package.
    package = pkgs-unstable.noctalia;
    # Neutral macOS-inspired surfaces with blue selection accents. Both
    # variants also supply ANSI colors for the existing application templates.
    customPalettes.macOS = {
      dark = {
        mPrimary = "#007AFF";
        mOnPrimary = "#FFFFFF";
        mSecondary = "#64D2FF";
        mOnSecondary = "#1C1C1E";
        mTertiary = "#BF5AF2";
        mOnTertiary = "#1C1C1E";
        mError = "#FF453A";
        mOnError = "#1C1C1E";
        mSurface = "#242426";
        mOnSurface = "#F5F5F7";
        mSurfaceVariant = "#303032";
        mOnSurfaceVariant = "#C7C7CC";
        mOutline = "#48484A";
        mShadow = "#000000";
        mHover = "#3A3A3C";
        mOnHover = "#FFFFFF";
        terminal = {
          background = "#1C1C1E";
          foreground = "#F5F5F7";
          cursor = "#F5F5F7";
          cursorText = "#1C1C1E";
          selectionBg = "#264F78";
          selectionFg = "#FFFFFF";
          normal = {
            black = "#1C1C1E";
            red = "#FF6961";
            green = "#6BD779";
            yellow = "#FFD60A";
            blue = "#66ABFF";
            magenta = "#D58CF6";
            cyan = "#64D2FF";
            white = "#D1D1D6";
          };
          bright = {
            black = "#8E8E93";
            red = "#FF938D";
            green = "#96E5A0";
            yellow = "#FFE566";
            blue = "#99C7FF";
            magenta = "#E4B5FA";
            cyan = "#A0E4FF";
            white = "#FFFFFF";
          };
        };
      };
      light = {
        mPrimary = "#0066CC";
        mOnPrimary = "#FFFFFF";
        mSecondary = "#006D8F";
        mOnSecondary = "#FFFFFF";
        mTertiary = "#8944AB";
        mOnTertiary = "#FFFFFF";
        mError = "#C9342B";
        mOnError = "#FFFFFF";
        mSurface = "#F5F5F7";
        mOnSurface = "#1D1D1F";
        mSurfaceVariant = "#EAEAED";
        mOnSurfaceVariant = "#5A5A60";
        mOutline = "#C7C7CC";
        mShadow = "#000000";
        mHover = "#DEDEE3";
        mOnHover = "#1D1D1F";
        terminal = {
          background = "#FFFFFF";
          foreground = "#1D1D1F";
          cursor = "#1D1D1F";
          cursorText = "#FFFFFF";
          selectionBg = "#B3D7FF";
          selectionFg = "#1D1D1F";
          normal = {
            black = "#1D1D1F";
            red = "#B42318";
            green = "#247A3C";
            yellow = "#8A6300";
            blue = "#0066CC";
            magenta = "#8944AB";
            cyan = "#006D8F";
            white = "#767680";
          };
          bright = {
            black = "#636366";
            red = "#C9342B";
            green = "#25823C";
            yellow = "#906800";
            blue = "#0070D6";
            magenta = "#9A3BB3";
            cyan = "#007894";
            white = "#F5F5F7";
          };
        };
      };
    };
    # Share the neutral surfaces and terminal ANSI colors with the blue theme.
    customPalettes.macOS-Red =
      let
        base = config.programs.noctalia.customPalettes.macOS;
      in
      {
        dark = base.dark // {
          mPrimary = "#FF4245";
          terminal = base.dark.terminal // {
            selectionBg = "#643033";
          };
        };
        light = base.light // {
          mPrimary = "#FF383C";
          terminal = base.light.terminal // {
            selectionBg = "#FFD2D3";
          };
        };
      };
    # This is the merged configuration exported by Noctalia. Keep settings
    # selected in the UI here so they are part of the standard configuration
    # rather than runtime overrides.
    settings = {
      config_version = 14;

      # Noctalia's 14px body becomes 13px. Other text sizes and controls
      # follow its built-in proportions; bar content is scaled separately.
      accessibility.ui_scale = 13.0 / 14.0;

      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
      };

      idle = {
        pre_action_fade_seconds = 0;
        behavior = {
          lock = {
            enabled = true;
            timeout = 600;
            action = "lock";
          };
          suspend = {
            enabled = true;
            timeout = 1800;
            action = "lock_and_suspend";
          };
        };
      };

      bar.order = [ "modern" ];
      bar.default.enabled = false;

      # Preserve the modern menu bar created in Settings, including its
      # transparent background and widget arrangement.
      bar.modern = {
        enabled = true;
        position = "top";
        background_opacity = 0.0;
        capsule = false;
        center = [ ];
        start = [
          "control-center"
          "workspaces"
          "active_window"
        ];
        end = [
          "media"
          "tray"
          "clipboard"
          "volume"
          "battery"
          "network"
          "clock"
          "notifications"
        ];
        concave_edge_corners = false;
        hover_highlight = false;
        margin_ends = 0;
        radius = 0;
        scale = 1.05;
        # Retain icon sizing while making the 14px labels 13px.
        font_scale = 13.0 / (14.0 * 1.05);
        font_weight = 400;
        shadow = false;
        thickness = 34;
        widget_spacing = 12;
      };

      calendar.enabled = true;

      control_center = {
        hidden_tabs = [ "monitor" ];
        calendar.show_week_numbers = true;
        shortcuts = map (type: { inherit type; }) [
          "caffeine"
          "nightlight"
          "notification"
          "dark_mode"
          "bluetooth"
          "wallpaper"
        ];
      };

      desktop_widgets = {
        schema_version = 2;
        widget_order = [ ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = { };
      };

      dock = {
        auto_hide = true;
        enabled = true;
        background_opacity = 0.5;
        border_width = 1.0;
        concave_edge_corners = false;
        icon_size = 48;
        magnification = false;
        magnification_scale = 1.2;
        margin_edge = 8;
        radius = 16;
        shadow = true;
        pinned = [
          "firefox"
          "com.mitchellh.ghostty"
          "dev.zed.Zed"
        ];
        reserve_space = false;
      };

      lockscreen_widgets.enabled = false;

      plugin_settings."noctalia/umbriel-companion".panel_placement = "floating";

      plugin_settings."noctalia/wallhaven" = {
        browser_open_near_click = true;
        browser_placement = "floating";
        download_dir = "${config.home.homeDirectory}/Downloads";
      };

      plugins.enabled = [
        "noctalia/umbriel-companion"
        "noctalia/wallhaven"
      ];

      shell = {
        app_icon_color = "secondary";
        avatar_path = toString ./assets/face.png;
        font_family = "SF Pro Text";
        corner_radius_scale = 0.75;
        button_borders = false;
        card_borders = false;
        input_borders = true;
        popup_borders = true;
        popup_shadows = true;
        polkit_agent = true;
        screen_time_enabled = true;
        settings_show_advanced = false;
        umbriel_overview_type_to_launch_enabled = true;
        animation.speed = 1.5;
        panel = {
          transparency_mode = "glass";
          borders = true;
          shadow = true;
          control_center_placement = "floating";
          open_near_click_control_center = true;
          open_near_click_session = true;
          open_near_click_wallpaper = true;
          session_placement = "floating";
          session_position = "center";
          wallpaper_placement = "floating";
        };
      };

      theme = {
        custom_palette = "macOS-Red";
        mode = "dark";
        source = "custom";
        wallpaper_scheme = "m3-content";
        templates = {
          builtin_ids = [
            "btop"
            "ghostty"
            "helix"
            "starship"
            "umbriel"
          ];
          community_ids = [
            "vscode"
            "zed"
            "bat"
          ];
        };
      };

      wallpaper = {
        directory = toString ./assets/wallpapers;
        transition_on_startup = true;
        default.path = toString ./assets/wallpapers/rosepine/ANVTM.jpg;
        last.path = toString ./assets/wallpapers/rosepine/ANVTM.jpg;
        monitors.${mainMonitor.name}.path = toString ./assets/wallpapers/rosepine/ANVTM.jpg;
      };

      widget = {
        control-center = {
          custom_image = toString ./assets/nixos-mono.svg;
          custom_image_colorize = true;
        };
        active_window = {
          display = "icon_and_text";
          font_weight = 600;
        };
        bar = {
          enable_scroll = false;
          scroll_cycles_layout = false;
          type = "noctalia/umbriel-companion:bar";
        };
        battery.enabled = true;
        bluetooth.enabled = false;
        brightness.enabled = false;
        caffeine.enabled = false;
        clipboard.enabled = false;
        clock = {
          font_scale = 1.05;
          format = "{:%a. %d. %b. %H:%M}";
        };
        date.format = "{:%a %d %b %H:%M}";
        launcher.enabled = false;
        media = {
          capsule = true;
          capsule_opacity = 0.0;
          capsule_padding = 12;
          enabled = true;
          hide_when_no_media = true;
          max_length = 500;
        };
        session.enabled = false;
        network.show_label = false;
        tray = {
          detached_panel = true;
          drawer = true;
        };
        volume.show_label = false;
        wallhaven.type = "noctalia/wallhaven:wallhaven";
        wallpaper.enabled = false;
        workspaces = {
          style = "minimal";
          show_labels = true;
          label_source = "name";
          labels_only_when_occupied = false;
          max_label_chars = 20;
          occupied_color = "on_surface_variant";
        };
      };
    };
  };
}
