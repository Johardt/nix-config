{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    discord
    adwsteamgtk
    unityhub
    protontricks
    winetricks
  ];
}
