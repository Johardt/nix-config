{
  config,
  lib,
  ...
}:

{
  programs.man.generateCaches = false;

  home.sessionVariables = {
    HOMEBREW_NO_ENV_HINTS = "1";
    SHELL_SESSIONS_DISABLE = "1";
    XDG_RUNTIME_DIR = "${config.home.homeDirectory}/.local/run";
  };

  programs.fish = {
    # nix-darwin initializes Homebrew; prefer Nix tools over Brew duplicates.
    shellInit = lib.mkBefore ''
      fish_add_path --move --path "$HOME/.nix-profile/bin" /run/current-system/sw/bin
    '';

    shellAliases = {
      oc = "opencode";
      pw = "packwiz";
    };
  };
}
