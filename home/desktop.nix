{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./umbriel.nix
  ];

  home.packages = with pkgs; [
    atuin-desktop
    bibata-cursors
    chromium
    geist-font
    inter
    nerd-fonts.adwaita-mono
    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    podman-desktop
    prismlauncher
    discord
    adwsteamgtk
  ];

  home.sessionVariables.TERMINAL = "ghostty";

  # Chromium uses these URL/profile-derived IDs for native Wayland app windows.
  # Matching the desktop file names lets GNOME associate the windows with the
  # friendly names and icons below instead of treating them as unknown apps.
  xdg.desktopEntries."chrome-mail.proton.me__u1_inbox-Default" = {
    name = "Proton Mail";
    genericName = "Email Client";
    comment = "Open Proton Mail";
    exec = "${pkgs.chromium}/bin/chromium --ozone-platform=wayland --app=https://mail.proton.me/u/1/inbox --user-data-dir=${config.xdg.dataHome}/proton-mail-pwa";
    icon = "proton-mail";
    terminal = false;
    categories = [
      "Network"
      "Email"
    ];
    settings = {
      StartupNotify = "true";
    };
  };

  xdg.desktopEntries."chrome-chatgpt.com__-Default" = {
    name = "ChatGPT";
    genericName = "AI Assistant";
    comment = "Open ChatGPT";
    exec = "${pkgs.chromium}/bin/chromium --ozone-platform=wayland --app=https://chatgpt.com/ --user-data-dir=${config.xdg.dataHome}/chatgpt-pwa";
    icon = "${./assets/chatgpt.svg}";
    terminal = false;
    categories = [
      "Network"
      "Utility"
    ];
    settings.StartupNotify = "true";
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "kdl"
      "toml"
    ];
    userSettings = builtins.fromJSON (builtins.readFile ./zed-settings.json);
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "dark:Catppuccin Macchiato,light:Catppuccin Latte";
      font-family = "GeistMono Nerd Font";
      font-size = 12;
      font-feature = "calt, liga, dlig";
      cursor-style = "bar";

      window-padding-x = 8;
      window-padding-y = 8;
      window-width = 118;
      confirm-close-surface = false;
      cursor-click-to-move = true;
      unfocused-split-opacity = 0.8;

      shell-integration = "detect";
      shell-integration-features = "ssh-env";

      keybind = [
        "alt+left=text:\\x1bb"
        "alt+right=text:\\x1bf"
        "super+left=text:\\x01"
        "super+right=text:\\x05"
        "super+t=new_tab"
        "super+k=text:\\x0c"
        "super+shift+r=text:reload\\x0d"
        "super+shift+g=text:git\\x20status\\x0d"
        "super+shift+l=text:ll\\x0d"
        "super+f=text:/"
        "super+shift+f=text:?"
      ];
    };
  };
}
