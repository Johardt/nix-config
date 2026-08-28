{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      # Noctalia owns the generated theme file. Keeping the selector here also
      # lets its apply hook leave Home Manager's read-only config untouched.
      theme = "noctalia";
      font-family = "GeistMono Nerd Font";
      font-size = 12;
      font-feature = "calt, liga, dlig";
      cursor-style = "bar";

      window-padding-x = 8;
      window-padding-y = 8;
      window-width = 118;
      confirm-close-surface = false;
      cursor-click-to-move = true;
      copy-on-select = false;
      unfocused-split-opacity = 0.8;

      shell-integration = "detect";
      shell-integration-features = "ssh-env";

      keybind = [
        "alt+left=text:\\x1bb"
        "alt+right=text:\\x1bf"
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
        "super+left=text:\\x01"
        "super+right=text:\\x05"
        "super+t=new_tab"
        "super+k=text:\\x0c"
        "super+shift+r=text:reload\\x0d"
        "super+shift+g=text:git\\x20status\\x0d"
        "super+shift+l=text:ll\\x0d"
        "super+f=text:/"
        "super+shift+f=text:?"
      ];
    };
  };
}
