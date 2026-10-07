{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  desktop = import ../../shared/desktop.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./desktop.nix
  ];

  # ---------------------------------------------------------------------------
  # Nix
  # ---------------------------------------------------------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    flake = "/home/joel/nixos";

    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 10";
    };
  };

  # Zed extensions may download prebuilt language servers that expect the
  # conventional Linux dynamic linker rather than Nix store paths.
  programs.nix-ld.enable = true;

  # ---------------------------------------------------------------------------
  # Btrfs
  # ---------------------------------------------------------------------------

  # The generated hardware configuration defines the devices and subvolumes;
  # keep policy such as compression and maintenance here.
  fileSystems."/".options = [
    "compress=zstd"
    "noatime"
  ];
  fileSystems."/home".options = [
    "compress=zstd"
    "noatime"
  ];
  fileSystems."/nix".options = [
    "compress=zstd"
    "noatime"
  ];

  # All three mounts live on the same Btrfs filesystem, so scrub it only once.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------

  # Keep recovery generations accessible through a brief, minimal menu at
  # the firmware's highest supported console resolution.
  boot.loader = {
    timeout = 2;

    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "max";
      editor = false;
    };

    efi.canTouchEfiVariables = true;
  };

  # Cover routine startup and shutdown output with the firmware-logo splash.
  # Errors remain available through the journal and by pressing Escape while
  # Plymouth is active.
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  # Plymouth otherwise starts on simpledrm and only becomes visible once the
  # NVIDIA DRM device appears near the end of boot. Load the graphics stack in
  # the initrd so Plymouth can render on the real display from early startup.
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  boot.kernelParams = [
    "quiet"
    # Unlike "auto", false does not reveal the unit-status wall when startup
    # or shutdown takes longer than systemd's status timeout.
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "udev.log_level=3"
    "rd.udev.log_level=3"
  ];

  # Required for unlocking LUKS2 volumes through enrolled TPM2 tokens. The
  # generated hardware module supplies the machine-specific LUKS device.
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."cryptroot".crypttabExtraOpts = [
    "tpm2-device=auto"
  ];
  # Let the periodic TRIM service reach the SSD through the encrypted volume.
  boot.initrd.luks.devices."cryptroot".allowDiscards = true;

  # Supported upstream stable series; keep current with 7.2 point releases.
  boot.kernelPackages = pkgs-unstable.linuxPackages_7_2;

  # Compressed swap provides breathing room for builds and desktop workloads.
  # This is a capacity limit, not a reservation of half the physical RAM.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------

  networking.hostName = "baremetal";
  networking.networkmanager.enable = true;

  # ---------------------------------------------------------------------------
  # Hardware maintenance and desktop integration
  # ---------------------------------------------------------------------------

  services.smartd = {
    enable = true;
    autodetect = true;
    notifications = {
      # Forward disk warnings from the system bus into the graphical session.
      systembus-notify.enable = true;
      wall.enable = true;
      x11.enable = false;
    };
  };

  # Start the notification bridge after Noctalia starts, and stop it alongside
  # the Umbriel session.
  systemd.user.services.systembus-notify = {
    wantedBy = lib.mkForce [ "umbriel-session.target" ];
    # Explicit ordering after the target prevents its default dependencies
    # from ordering it after this bridge and creating a cycle with Noctalia.
    after = [
      "umbriel-session.target"
      "noctalia.service"
    ];
    partOf = [ "umbriel-session.target" ];
  };

  services.fwupd.enable = true;
  services.gvfs.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ---------------------------------------------------------------------------
  # Locale / keyboard
  # ---------------------------------------------------------------------------

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.xkb = desktop.keyboard;

  console.keyMap = "de";

  # ---------------------------------------------------------------------------
  # Audio
  # ---------------------------------------------------------------------------

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Printing
  # ---------------------------------------------------------------------------

  services.printing.enable = true;

  # ---------------------------------------------------------------------------
  # User
  # ---------------------------------------------------------------------------

  users.users.joel = {
    isNormalUser = true;
    description = "Joel";
    shell = pkgs.fish;
    extraGroups = [
      "logitech"
      "networkmanager"
      "wheel"
    ];
  };

  # ---------------------------------------------------------------------------
  # Programs that need system-level configuration
  # ---------------------------------------------------------------------------

  home-manager.users.joel.programs.firefox.profiles.default = {
    # Keep using the existing profile on this host.
    path = "e3ifv08l.default";
    # This keyboard maps its Command-style modifier to Super.
    settings."ui.key.accelKey" = 224;
  };
  programs.fish.enable = true;

  # Podman Desktop was part of the portable desktop toolset. Enable its native
  # NixOS backend and Docker-compatible socket/API rather than relying on a
  # macOS VM such as Lima.
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  # ---------------------------------------------------------------------------
  # 1Password
  # ---------------------------------------------------------------------------

  programs._1password.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "joel" ];
  };

  # ---------------------------------------------------------------------------
  # NixOS version
  # ---------------------------------------------------------------------------

  system.stateVersion = "26.05";
}
