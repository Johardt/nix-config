{
  lib,
  pkgs,
  pkgs-unstable,
  apple-fonts,
  hatter,
  ...
}:

let
  hatter-icon-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "hatter-icon-theme";
    version = "unstable-${hatter.shortRev}";
    src = hatter;
    dontBuild = true;
    propagatedBuildInputs = [ pkgs.adwaita-icon-theme ];
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/icons"
      cp -a Hatter "$out/share/icons/"
      runHook postInstall
    '';
    meta = {
      description = "Rounded square icon theme preserving application identities";
      homepage = "https://github.com/Mibea/Hatter";
      license = pkgs.lib.licenses.gpl3Only;
      platforms = pkgs.lib.platforms.linux;
    };
  };
in
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
      podman-desktop
      prismlauncher
      discord
      adwsteamgtk
      unityhub
      appimage-run
      gimp
      protontricks
      winetricks
      loupe
    ])
    ++ (with pkgs-unstable; [
      # Keep manual server settings accessible for Proton Bridge, and fix
      # the SMTP login selector in Convey 50.2-1.
      (convey.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../packages/patches/convey-account-settings.patch ];
      }))
      openlogi
      protonmail-bridge-gui
    ])
    ++ [
      apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
    ];

  fonts.fontconfig.enable = true;

  services.protonmail-bridge = {
    enable = true;
    package = pkgs-unstable.protonmail-bridge;
  };
  systemd.user.services.protonmail-bridge = {
    Unit = {
      After = lib.mkForce [ "umbriel-session.target" "oo7-daemon.service" ];
      PartOf = [ "umbriel-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "umbriel-session.target" ];
  };

  # The headless service replaces Bridge's GUI-created login launcher.
  xdg.configFile."autostart/ProtonMailBridge.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Type=Application
      Name=ProtonMailBridge
      Hidden=true
    '';
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Hatter";
      package = hatter-icon-theme;
    };
  };

  # Noctalia checks GSettings before the GTK settings files.
  dconf.settings."org/gnome/desktop/interface".icon-theme = "Hatter";

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
