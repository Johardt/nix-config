{ pkgs, ... }:

{
  # GDM presents both GNOME and Niri as selectable login sessions.
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;

  services.desktopManager.gnome.enable = true;
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    ghostty
    noctalia-shell
    xwayland-satellite
  ];
}
