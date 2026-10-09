{ sofka, ... }:

{
  imports = [
    ../../home/shell
    ../../home/development.nix
    ../../home/apps/editors.nix
    sofka.homeManagerModules.default
    ./terminal.nix
    ../../home/apps/ghostty.nix
    ../../home/apps/zed.nix
    ./fish.nix
  ];

  home.username = "joel";
  home.homeDirectory = "/Users/joel";
  home.stateVersion = "26.05";

  xdg.enable = true;
  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    darwinFlake = "path:/Users/joel/nix-config#darwinConfigurations.macbook";
  };

  # Helix 25.07.1 supports a single theme, without automatic light/dark switching.
  programs.helix.settings.theme = "catppuccin_mocha";
  programs.sofka.enable = true;
}
