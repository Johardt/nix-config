{ pkgs-unstable, ... }:

{
  # The existing history database has migrations newer than stable Atuin.
  programs.atuin.package = pkgs-unstable.atuin;

  programs.bat.config = {
    theme = "auto:system";
    theme-dark = "Catppuccin Macchiato";
    theme-light = "Catppuccin Latte";
  };
}
