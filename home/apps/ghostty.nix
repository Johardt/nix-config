{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  modifier = if isDarwin then "cmd" else "super";
  gitStatus = if isDarwin then "git\\ status" else "git\\x20status";
in
{
  programs.ghostty = {
    enable = true;
    # On macOS, nix-darwin's Homebrew cask owns the application.
    package = if isDarwin then null else pkgs.ghostty;
    settings = {
      # Noctalia owns the generated theme file. Keeping the selector here also
      # lets its apply hook leave Home Manager's read-only config untouched.
      theme = if isDarwin then "dark:Catppuccin Macchiato,light:Catppuccin Latte" else "noctalia";
      font-family = "GeistMono Nerd Font";
      font-size = if isDarwin then 14 else 12;
      font-feature = "calt, liga, dlig";
      cursor-style = "bar";

      window-padding-x = 8;
      window-padding-y = 8;
      window-width = 118;
      confirm-close-surface = false;
      cursor-click-to-move = true;
      unfocused-split-opacity = 0.8;

      shell-integration = "detect";
      shell-integration-features = "ssh-env";

      keybind = [
        "alt+left=text:\\x1bb"
        "alt+right=text:\\x1bf"
      ]
      ++ lib.optionals (!isDarwin) [
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
      ]
      ++ [
        "${modifier}+left=text:\\x01"
        "${modifier}+right=text:\\x05"
      ]
      ++ lib.optionals (!isDarwin) [
        "super+t=new_tab"
      ]
      ++ [
        "${modifier}+k=text:\\x0c"
        "${modifier}+shift+r=text:reload\\x0d"
        "${modifier}+shift+g=text:${gitStatus}\\x0d"
        "${modifier}+shift+l=text:ll\\x0d"
        "${modifier}+f=text:/"
        "${modifier}+shift+f=text:?"
      ]
      ++ lib.optionals isDarwin [
        "global:ctrl+grave_accent=toggle_quick_terminal"
      ];
    }
    // lib.optionalAttrs isDarwin {
      # Use the Nix shell even when the GUI session still has Brew's SHELL value.
      command = "/run/current-system/sw/bin/fish";
      window-height = 33;
      macos-icon = "xray";
      macos-titlebar-style = "tabs";
      macos-option-as-alt = false;
    }
    // lib.optionalAttrs (!isDarwin) {
      copy-on-select = false;
    };
  };
}
