{ pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./umbriel.nix
  ];

  home.packages = with pkgs; [
    atuin-desktop
    bibata-cursors
    geist-font
    inter
    nerd-fonts.adwaita-mono
    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    podman-desktop
    prismlauncher
  ];

  home.sessionVariables.TERMINAL = "ghostty";

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
      font-size = 13;
      font-feature = "calt, liga, dlig";
      cursor-style = "bar";

      window-padding-x = 8;
      window-padding-y = 8;
      window-height = 33;
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
