{ pkgs, ... }:

{
  imports = [ ./homebrew.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = with pkgs; [
    adwaita-fonts
    nerd-fonts.adwaita-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono
    maple-mono.NF
    nerd-fonts.symbols-only
  ];

  system.primaryUser = "joel";
  system.stateVersion = 6;

  users.users.joel.home = "/Users/joel";
  users.users.joel.shell = pkgs.fish;
  programs.fish.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "before-home-manager";
    users.joel = import ./home.nix;
  };
}
