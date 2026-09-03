{ noctalia, pkgs-unstable, ... }:

{
  imports = [ noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    # Noctalia v5 from nixpkgs-unstable. This is intentionally `noctalia`,
    # not the legacy Quickshell-based `noctalia-shell` package.
    package = pkgs-unstable.noctalia;
    # This is the merged configuration exported by Noctalia. Keep settings
    # selected in the UI here so they are part of the standard configuration
    # rather than runtime overrides.
    settings = {
      config_version = 13;

      bar.default = {
        background_opacity = 0.0;
        capsule = true;
        center = [ "group:g1" ];
        concave_edge_corners = false;
        end = [
          "media"
          "group:g3"
        ];
        margin_ends = 0;
        radius = 0;
        shadow = false;
        start = [
          "group:g4"
          "group:g2"
        ];
        widget_spacing = 12;
        dead_zone.actions.right = "none";
        capsule_group = [
          {
            accordion = false;
            accordion_direction = "end";
            enabled = true;
            fill = "surface_variant";
            id = "g1";
            members = [
              "date"
              "notifications"
            ];
            opacity = 1.0;
            padding = 12.0;
          }
          {
            accordion = false;
            accordion_direction = "end";
            enabled = true;
            fill = "surface_variant";
            id = "g2";
            members = [
              "workspaces"
              "active_window"
            ];
            opacity = 1.0;
            padding = 12.0;
          }
          {
            accordion = false;
            accordion_direction = "end";
            enabled = true;
            fill = "surface_variant";
            id = "g3";
            members = [
              "tray"
              "clipboard"
              "bluetooth"
              "volume"
              "brightness"
              "battery"
              "session"
              "control-center"
            ];
            opacity = 1.0;
            padding = 12.0;
          }
          {
            accordion = true;
            accordion_direction = "end";
            enabled = true;
            fill = "surface_variant";
            id = "g4";
            members = [
              "launcher"
              "bar"
            ];
            opacity = 1.0;
            padding = 6.0;
          }
        ];
      };

      battery.device."/org/freedesktop/UPower/devices/battery_hidpp_battery_0".warning_threshold = 20;

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
        pinned = [
          "org.gnome.Nautilus"
          "firefox"
          "com.mitchellh.ghostty"
          "dev.zed.Zed"
        ];
        reserve_space = false;
      };

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [ "lockscreen-login-box@DP-1" ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget."lockscreen-login-box@DP-1" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 1280.0;
          cy = 1258.0;
          output = "DP-1";
          placement_height = 1440.0;
          placement_width = 2560.0;
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
      };

      plugin_settings."noctalia/umbriel-companion".panel_placement = "floating";

      plugins.enabled = [ "noctalia/umbriel-companion" ];

      shell = {
        app_icon_color = "secondary";
        avatar_path = toString ./assets/face.png;
        font_family = "Adwaita Sans";
        polkit_agent = true;
        screen_time_enabled = true;
        settings_show_advanced = false;
        animation.speed = 1.5;
        panel = {
          control_center_placement = "floating";
          open_near_click_control_center = true;
          open_near_click_wallpaper = true;
          wallpaper_placement = "floating";
        };
      };

      theme = {
        builtin = "Catppuccin";
        community_palette = "ADW";
        mode = "auto";
        source = "builtin";
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
            "zen-browser"
            "vscode"
            "zed"
            "bat"
          ];
          # Noctalia 5.0.0's bundled template still uses Umbriel's old color
          # keys. Keep the palette integration while the two projects converge.
          user.umbriel = {
            input_path = toString ./assets/umbriel.toml;
            output_path = "$XDG_CONFIG_HOME/umbriel/noctalia.toml";
          };
        };
      };

      wallpaper = {
        directory = toString ./assets/wallpapers;
        transition_on_startup = true;
        default.path = toString ./assets/wallpapers/rosepine/point-overhead.jpg;
        last.path = toString ./assets/wallpapers/rosepine/point-overhead.jpg;
        monitors.DP-1.path = toString ./assets/wallpapers/rosepine/point-overhead.jpg;
      };

      widget = {
        bar.type = "noctalia/umbriel-companion:bar";
        battery.enabled = false;
        bluetooth.enabled = false;
        brightness.enabled = false;
        caffeine.enabled = false;
        date.format = "{:%a %d %b %H:%M}";
        media = {
          capsule = true;
          capsule_padding = 12;
          enabled = true;
          hide_when_no_media = true;
          max_length = 500;
        };
        session.enabled = false;
        tray = {
          detached_panel = true;
          drawer = true;
          hidden = [ "/org/ayatana/NotificationItem/ibus_ui_gtk3" ];
        };
        volume.show_label = false;
        wallpaper.enabled = false;
      };
    };
  };
}
