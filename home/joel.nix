{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./gnome.nix
  ];

  home.username = "joel";
  home.homeDirectory = "/home/joel";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    curl
    wget
    ripgrep
    fd
    jq
    tree
    codex
  ];

  programs.git = {
    enable = true;
    settings.include.path = "~/.gitconfig.local";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };

  programs.bash.enable = true;

  programs.zed-editor.enable = true;

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "CLI"
  '';

  programs.home-manager.enable = true;
}
