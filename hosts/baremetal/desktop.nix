{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  desktop = import ../../shared/desktop.nix;
in
{
  services.displayManager.noctalia-greeter = {
    enable = true;
    # Use the nixpkgs-unstable package, alongside Noctalia v5. The Git input
    # remains responsible for the NixOS module and its configuration options.
    package = pkgs-unstable.noctalia-greeter;
    # Caps is remapped by Kanata below, before the XKB keymap is applied.
    settings = {
      keyboard = desktop.keyboard;
      cursor = {
        theme = desktop.cursor.theme;
        size = desktop.cursor.size;
        path = pkgs.bibata-cursors;
      };
      session.default = "Umbriel";
    };
  };

  programs.umbriel.enable = true;

  # NixOS 26.05 predates services.oo7 and its PAM option. Use the unstable
  # packages with the same daemon, D-Bus and capability-wrapper integration.
  services.dbus.packages = [
    pkgs-unstable.oo7-server
    # oo7 delegates graphical password dialogs to GCR's SystemPrompter.
    pkgs.gcr
  ];
  systemd.packages = [ pkgs-unstable.oo7-server ];
  systemd.user.services.oo7-daemon = {
    wantedBy = [ "default.target" ];
    aliases = [ "dbus-org.freedesktop.secrets.service" ];
  };
  security.wrappers.oo7-daemon = {
    owner = "root";
    group = "root";
    capabilities = "cap_ipc_lock=ep";
    source = "${pkgs-unstable.oo7-server}/libexec/oo7-daemon";
  };

  # Capture the login password before PAM's sufficient authentication rules
  # can return, then unlock the keyring when the user session opens.
  security.pam.services = lib.genAttrs [ "greetd" "login" "passwd" ] (name: {
    rules = {
      auth.oo7-unix = {
        order = config.security.pam.services.${name}.rules.auth.unix.order - 20;
        control = "optional";
        modulePath = "${pkgs.pam}/lib/security/pam_unix.so";
        settings = {
          try_first_pass = true;
          likeauth = true;
        };
      };
      auth.oo7 = {
        order = config.security.pam.services.${name}.rules.auth.unix.order - 10;
        control = "optional";
        modulePath = "${pkgs-unstable.oo7-pam}/lib/security/pam_oo7.so";
      };
      session.oo7 = {
        order = config.security.pam.services.${name}.rules.session.gnome_keyring.order + 1;
        control = "optional";
        modulePath = "${pkgs-unstable.oo7-pam}/lib/security/pam_oo7.so";
        settings.auto_start = true;
      };
      password.oo7 = {
        order = config.security.pam.services.${name}.rules.password.gnome_keyring.order + 1;
        control = "optional";
        modulePath = "${pkgs-unstable.oo7-pam}/lib/security/pam_oo7.so";
      };
      # Let oo7 see password changes after pam_unix has updated the account.
      password.unix.control = lib.mkForce "required";
    };
  });

  xdg.portal = {
    extraPortals = [ pkgs-unstable.oo7-portal ];
    config.umbriel."org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
  };

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

  # OpenLogi needs HID access to the installed Unifying and Bolt receivers.
  # Keep this separate from Kanata's raw-input and event-injection groups.
  users.groups.logitech = { };

  # Restore the uinput group permissions after Steam's per-session uaccess
  # rule so Kanata's dynamic user retains access.
  services.udev.extraRules = ''
    SUBSYSTEM=="misc", KERNEL=="uinput", RUN+="${pkgs.acl}/bin/setfacl -m g::rw /dev/uinput"
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b|c548", GROUP="logitech", MODE="0660"
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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Preserve NVIDIA video memory across suspend outside a potentially
  # size-constrained tmpfs to avoid incomplete Wayland resumes.
  boot.kernelParams = [ "nvidia.NVreg_TemporaryFilePath=/var/tmp" ];

  # Steam needs system-level integration for its runtime and 32-bit graphics
  # stack, so use the NixOS module instead of adding the package directly.
  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs-unstable.oo7
    pkgs.bubblewrap
    pkgs.xwayland-satellite
  ];
}
