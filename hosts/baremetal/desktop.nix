{ config, pkgs, pkgs-unstable, ... }:

{
  # GDM presents both GNOME and Niri as selectable login sessions.
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;

  services.desktopManager.gnome.enable = true;
  programs.niri = {
    enable = true;
    package = pkgs-unstable.niri;
  };

  # Use the proprietary user-space driver with
  # NVIDIA's supported open kernel module instead of nouveau.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Steam needs system-level integration for its runtime and 32-bit graphics
  # stack, so use the NixOS module instead of adding the package directly.
  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs.ghostty
    pkgs-unstable.noctalia-shell
    pkgs.xwayland-satellite
  ];
}
