{ config, pkgs, ... }:

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

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Linux 7.2 does not currently compile with NVIDIA 595. 7.1 is the newest
  # kernel in this nixpkgs snapshot with a working NVIDIA open kernel module.
  boot.kernelPackages = pkgs.linuxPackages_7_1;

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------

  networking.hostName = "nixos";
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

  services.xserver.xkb = {
    layout = "de";
    variant = "mac_nodeadkeys";
  };

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
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # ---------------------------------------------------------------------------
  # Programs that need system-level configuration
  # ---------------------------------------------------------------------------

  programs.firefox.enable = true;

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
