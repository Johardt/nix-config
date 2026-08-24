{ config, pkgs, nirimod, ... }:

{
  home.packages = [
    nirimod.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.prismlauncher
  ];

  # Keep the Niri session deliberately small. Noctalia provides its shell,
  # launcher, notifications, and other desktop UI.
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/niri/config.kdl";
}
