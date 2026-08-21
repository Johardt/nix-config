{ ... }:

{
  # Keep the Niri session deliberately small. Noctalia provides its shell,
  # launcher, notifications, and other desktop UI.
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "de"
                variant "mac_nodeadkeys"
                options "caps:hyper"
            }
        }

        touchpad {
            natural-scroll
        }
    }

    layout {
        gaps 16

        focus-ring {
            width 4
            active-color "#7fc8ff"
            inactive-color "#505050"
        }

        border {
            off
        }
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    spawn-at-startup "noctalia-shell"
    spawn-at-startup "xwayland-satellite"

    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    binds {
        Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+Shift+O { show-hotkey-overlay; }
        Mod+T { spawn "ghostty"; }
        Mod+Q { close-window; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Print { screenshot; }
        Mod+Escape { toggle-keyboard-shortcuts-inhibit; }
    }
  '';
}
