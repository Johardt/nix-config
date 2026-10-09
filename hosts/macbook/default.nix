{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
