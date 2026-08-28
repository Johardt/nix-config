{ ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "kdl"
      "toml"
    ];
    userSettings = builtins.fromJSON (builtins.readFile ./zed-settings.json);
  };
}
