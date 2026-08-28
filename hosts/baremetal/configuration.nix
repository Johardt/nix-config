{ pkgs, ... }:

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
      extraArgs = "--keep-since 7d --keep 3";
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Required for unlocking LUKS2 volumes through enrolled TPM2 tokens. The
  # generated hardware module supplies the machine-specific LUKS device.
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."cryptroot".crypttabExtraOpts = [
    "tpm2-device=auto"
  ];

  # Linux 7.2 does not currently compile with NVIDIA 595. 7.1 is the newest
  # kernel in this nixpkgs snapshot with a working NVIDIA open kernel module.
  boot.kernelPackages = pkgs.linuxPackages_7_1;

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------

  networking.hostName = "baremetal";
  networking.networkmanager.enable = true;

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
