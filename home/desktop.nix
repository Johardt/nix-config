{ pkgs, ... }:

{
  imports = [
    ./apps
    ./gnome.nix
    ./noctalia.nix
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
    nerd-fonts.symbols-only
    papirus-icon-theme
    podman-desktop
    prismlauncher
    discord
    adwsteamgtk
    unityhub
    appimage-run
    opencode-desktop
    gimp
    protontricks
    winetricks
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

}
