{ noctalia, ... }:

{
  imports = [ noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    # Keep this sparse: unspecified values continue to follow Noctalia's
    # defaults, while the choices made in the settings UI are reproducible.
    settings = {
      config_version = 13;

      bar.default = {
        start = [
          "launcher"
          "workspaces"
          "active_window"
        ];
        center = [
          "date"
          "notifications"
        ];
        end = [
          "media"
          "tray"
          "clipboard"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
          "control-center"
        ];
        widget_spacing = 12;
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
          "system"
        ];
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

      shell = {
        app_icon_color = "secondary";
        font_family = "Adwaita Sans";
        polkit_agent = true;
        settings_show_advanced = false;
      };

      theme = {
        builtin = "Rosé Pine";
        community_palette = "ADW";
        mode = "light";
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
            "zed"
            "bat"
          ];
        };
      };

      widget = {
        bluetooth.enabled = false;
        date.format = "{:%a %d %b %H:%M}";
        media.enabled = false;
        session.enabled = false;
        tray = {
          drawer = true;
          hidden = [ "/org/ayatana/NotificationItem/ibus_ui_gtk3" ];
        };
        wallpaper.enabled = false;
      };
    };
  };
}
