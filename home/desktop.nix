{
  pkgs,
  pkgs-unstable,
  apple-fonts,
  ...
}:

{
  imports = [
    ./apps
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
      nautilus
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
      gimp
      protontricks
      winetricks
    ])
    ++ (with pkgs-unstable; [
      openlogi
    ])
    ++ [ apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro ];

  fonts.fontconfig.enable = true;

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
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

}
