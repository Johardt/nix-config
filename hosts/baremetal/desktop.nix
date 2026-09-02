{ config, pkgs, pkgs-unstable, ... }:

let
  desktop = import ../../shared/desktop.nix;
in
{
  # Keep the GNOME session available alongside Umbriel.
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-music
    gnome-console
    gnome-system-monitor
    epiphany
  ];

  programs.noctalia-greeter = {
    enable = true;
    # Use the nixpkgs-unstable package, alongside Noctalia v5. The Git input
    # remains responsible for the NixOS module and its configuration options.
    package = pkgs-unstable.noctalia-greeter;
    # Caps is remapped by Kanata below, before the XKB keymap is applied.
    settings.keyboard = desktop.keyboard;
  };

  programs.umbriel.enable = true;

  # GTK and Qt use Wayland's text-input protocol instead of legacy IM module
  # environment variables. XMODIFIERS remains available to Xwayland clients.
  i18n.inputMethod.ibus.waylandFrontend = true;

  # Match the keyboard's macOS legends before XKB sees the keys: the physical
  # Option/Super keys become left Alt (and therefore Level3 via
  # shared/desktop.nix), while the physical Command/Alt keys become Super.
  # Normalizing both Option keys to left Alt avoids right Alt being treated as
  # AltGr before its Level3 state reaches clients. The MX Keys reports its
  # physical right Option key as Right Ctrl, so normalize that key as well.
  # Caps remains a dedicated Ctrl+Shift+Super chord.
  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
          caps lalt lmet ralt rmet rctl
        )

        (defalias
          hyper (multi lsft lctl lmet)
        )

        (deflayer base
          @hyper lmet lalt rmet lalt lalt
        )
      '';
    };
  };

  # systemd creates static uinput nodes as root:root 0600.  Keep the mode from
  # hardware.uinput's udev rule when tmpfiles recreates the node.
  systemd.tmpfiles.rules = [ "z /dev/uinput 0660 root uinput -" ];

  # Steam's per-session uaccess ACL masks the owning group's permissions.
  # Restore them after uaccess so Kanata's dynamic user retains group access.
  services.udev.extraRules = ''
    SUBSYSTEM=="misc", KERNEL=="uinput", RUN+="${pkgs.acl}/bin/setfacl -m g::rw /dev/uinput"
  '';

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
