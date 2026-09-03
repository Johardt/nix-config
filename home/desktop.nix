{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./apps
    ./gnome.nix
    ./noctalia.nix
    ./umbriel.nix
  ];

  home.packages =
    (with pkgs; [
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
    ])
    ++ (with pkgs-unstable; [
      openlogi
    ]);

  home.sessionVariables.TERMINAL = "ghostty";

  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
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

}
