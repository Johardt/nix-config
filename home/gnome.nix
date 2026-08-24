{ config, pkgs, ... }:

let
  extensions = with pkgs.gnomeExtensions; [
    dash-to-dock
    blur-my-shell
    rounded-window-corners-reborn
    vicinae
  ];
in
{
  home.packages =
    extensions
    ++ (with pkgs; [
      gnome-extension-manager
      gnome-tweaks
      bibata-cursors
      geist-font
      inter
      nerd-fonts.adwaita-mono
      nerd-fonts.geist-mono
      nerd-fonts.jetbrains-mono
      papirus-icon-theme
    ]);

  programs.vicinae = {
    enable = true;

    systemd = {
      enable = true;
      autoStart = true;
    };

    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;

      font.normal = {
        size = 12;
        family = "Adwaita Sans";
      };

      theme = {
        light = {
          name = "catppuccin-latte";
          icon_theme = "Papirus";
        };
        dark = {
          name = "catppuccin-macchiato";
          icon_theme = "Papirus";
        };
      };

      launcher_window.opacity = 1.0;
    };
  };

  systemd.user.services.vicinae.Service.Environment = [
    "XDG_DATA_DIRS=${config.home.profileDirectory}/share:/run/current-system/sw/share"
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-enable-primary-paste = false;
      font-name = "Inter Medium 11";
      document-font-name = "Adwaita Sans 11";
      monospace-font-name = "JetBrainsMono NF 12";
      cursor-theme = "Bibata-Modern-Classic";
      icon-theme = "Papirus";
    };

    "org/gnome/shell" = {
      enabled-extensions = map (extension: extension.extensionUuid) extensions;
      favorite-apps = [
        "firefox.desktop"
        "com.mitchellh.ghostty.desktop"
        "dev.zed.Zed.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
      border-radius = 16;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae" = {
      name = "Vicinae";
      command = "vicinae toggle";
      binding = "<Alt>space";
    };

    "org/gnome/desktop/wm/keybindings" = {
      panel-main-menu = [ ];
      activate-window-menu = [ ];
    };
  };
}
