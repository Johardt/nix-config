{ config, pkgs, ... }:

{
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

  programs.home-manager.enable = true;
}
