{ pkgs, ... }:

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
