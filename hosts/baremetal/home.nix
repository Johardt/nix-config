{ config, pkgs, ... }:

let
  dotnet = pkgs.dotnetCorePackages.sdk_10_0;
in
{
  imports = [
    ../../home/desktop.nix
    ../../home/shell
    ../../home/apps/editors.nix
  ];

  home.username = "joel";
  home.homeDirectory = "/home/joel";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    dotnet
    luarocks
    nixd
    nixfmt
    biome
    bun
    _7zip-zstd
    dig
  ];

  _module.args.mainMonitor = {
    name = "DP-1";
    width = 2560;
    height = 1440;
  };

  programs.noctalia.settings = {
    battery.device."/org/freedesktop/UPower/devices/battery_hidpp_battery_0".warning_threshold = 20;
  };

  # Adopt the existing profile registry. The host-specific profile path is
  # declared below, so replacing this metadata file does not
  # replace or migrate any profile data.
  home.file.".config/mozilla/firefox/profiles.ini".force = true;

  programs.firefox.profiles.default = {
    # Keep using the existing profile on this host.
    path = "e3ifv08l.default";
    # This keyboard maps its Command-style modifier to Super.
    settings."ui.key.accelKey" = 224;
  };

  programs.zed-editor.userSettings.lsp.nixd.settings.nixd = {
    nixpkgs.expr = "import (builtins.getFlake \"${config.home.homeDirectory}/nixos\").inputs.nixpkgs { }";
    options = {
      nixos.expr = "(builtins.getFlake \"${config.home.homeDirectory}/nixos\").nixosConfigurations.baremetal.options";
      home-manager.expr =
        "(builtins.getFlake \"${config.home.homeDirectory}/nixos\").nixosConfigurations.baremetal.options.home-manager.users.type.getSubOptions []";
    };
  };

  programs.bash.enable = true;

  programs.bat.config.theme = "noctalia";

  programs.helix.settings.theme = "noctalia";
  # Atuin creates a regular default config on first launch. Home Manager owns
  # this path now; account state, encryption keys, and history live elsewhere.
  xdg.configFile."atuin/config.toml".force = pkgs.lib.mkForce true;

  home.sessionVariables.DOTNET_ROOT = "${dotnet.unwrapped}/share/dotnet";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*".IdentityAgent = "~/.1password/agent.sock";
  };

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "CLI"
  '';

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig.settings.color_theme = "catppuccin";
  };

  programs.home-manager.enable = true;
}
