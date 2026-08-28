{ config, pkgs, ... }:

let
  ciderLauncher = pkgs.writeShellApplication {
    name = "cider";
    runtimeInputs = [
      pkgs.appimage-run
      pkgs.libnotify
    ];
    text = ''
      app_image="$HOME/Applications/Cider.AppImage"

      if [[ ! -f "$app_image" ]]; then
        notify-send \
          --app-name="Cider" \
          --icon="${../assets/cider.svg}" \
          "Cider is not installed" \
          "Download the Cider AppImage and save it as ~/Applications/Cider.AppImage"
        exit 1
      fi

      exec appimage-run "$app_image" "$@"
    '';
  };
in
{
  home.packages = [ ciderLauncher ];

  # Chromium uses these URL/profile-derived IDs for native Wayland app windows.
  # Matching the desktop file names lets the compositor associate the windows
  # with these friendly names and icons.
  xdg.desktopEntries."chrome-mail.proton.me__u1_inbox-Default" = {
    name = "Proton Mail";
    genericName = "Email Client";
    comment = "Open Proton Mail";
    exec = "${pkgs.chromium}/bin/chromium --ozone-platform=wayland --app=https://mail.proton.me/u/1/inbox --user-data-dir=${config.xdg.dataHome}/proton-mail-pwa";
    icon = "proton-mail";
    terminal = false;
    categories = [
      "Network"
      "Email"
    ];
    settings.StartupNotify = "true";
  };

  xdg.desktopEntries."chrome-chatgpt.com__-Default" = {
    name = "ChatGPT";
    genericName = "AI Assistant";
    comment = "Open ChatGPT";
    exec = "${pkgs.chromium}/bin/chromium --ozone-platform=wayland --app=https://chatgpt.com/ --user-data-dir=${config.xdg.dataHome}/chatgpt-pwa";
    icon = "${../assets/chatgpt.svg}";
    terminal = false;
    categories = [
      "Network"
      "Utility"
    ];
    settings.StartupNotify = "true";
  };

  xdg.desktopEntries.cider = {
    name = "Cider";
    genericName = "Music Player";
    comment = "A cross-platform Apple Music client";
    exec = "${ciderLauncher}/bin/cider %U";
    icon = "${../assets/cider.svg}";
    terminal = false;
    categories = [
      "Audio"
      "AudioVideo"
    ];
    mimeType = [
      "x-scheme-handler/ame"
      "x-scheme-handler/cider"
      "x-scheme-handler/itms"
      "x-scheme-handler/itmss"
      "x-scheme-handler/musics"
      "x-scheme-handler/music"
    ];
    settings = {
      StartupNotify = "true";
      StartupWMClass = "Cider";
    };
  };
}
