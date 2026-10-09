{ lib, pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [
    # Keep manual server settings accessible for Proton Bridge, and fix
    # the SMTP login selector in Convey 50.2-1.
    (convey.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ../../packages/patches/convey-account-settings.patch ];
    }))
    protonmail-bridge-gui
  ];

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

}
