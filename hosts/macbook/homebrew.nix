{ ... }:

{
  nix-homebrew = {
    enable = true;
    user = "joel";
    autoMigrate = true;
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    taps = [
      "anomalyco/tap"
      { name = "boostsecurityio/tap"; trusted = true; }
      { name = "cormacrelf/tap"; trusted = true; }
      "ionos-cloud/ionos-cloud"
      { name = "stackitcloud/tap"; trusted = true; }
    ];

    # Explicitly installed formulae; Homebrew resolves their dependencies.
    brews = [
      { name = "anomalyco/tap/opencode-v2"; trusted = true; }
      "bagel"
      "container"
      "cormacrelf/tap/dark-notify"
      "nono"
      "ollama"
    ];

    casks = [
      "1password"
      "1password-cli@beta"
      "alcove"
      "atuin-desktop"
      "blender"
      "caskhub"
      "claude-code"
      "coderabbit"
      "container"
      "cursor"
      "firefox"
      "ghostty"
      "godot"
      "headlamp"
      "hyperkey"
      "inkscape"
      "linear"
      "notion"
      "podman-desktop"
      "prismlauncher"
      "protonvpn"
      "raycast"
      "secretive"
      "session-manager-plugin"
      "slack"
      "stackitcloud/tap/stackit"
      "ungoogled-chromium"
      "unity-cli"
      "visual-studio-code"
      "zed"
      "zen"
      "zoom"
    ];
  };
}
