{ config, pkgs, ... }:

let
  desktop = import ../../shared/desktop.nix;
in
{
  # Keep the GNOME session available alongside Umbriel.
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.noctalia-greeter = {
    enable = true;
    # Caps is remapped by Kanata below, before the XKB keymap is applied.
    settings.keyboard = desktop.keyboard;
  };

  programs.umbriel.enable = true;

  # Present Caps as the conventional Hyper chord.  Doing this below XKB makes
  # it usable by compositors that do not recognize XKB's Mod3/Hyper modifier.
  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
          caps
        )

        (defalias
          hyper (multi lsft lctl lalt lmet)
        )

        (deflayer base
          @hyper
        )
      '';
    };
  };

  # Use the proprietary user-space driver with
  # NVIDIA's supported open kernel module instead of nouveau.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Preserve NVIDIA video memory across suspend outside a potentially
  # size-constrained tmpfs to avoid incomplete GNOME/Wayland resumes.
  boot.kernelParams = [ "nvidia.NVreg_TemporaryFilePath=/var/tmp" ];

  # Steam needs system-level integration for its runtime and 32-bit graphics
  # stack, so use the NixOS module instead of adding the package directly.
  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];
}
