{ pkgs, ... }:

let
  dotnet = pkgs.dotnetCorePackages.sdk_10_0;
in
{
  imports = [
    ./desktop.nix
    ./shell
  ];

  home.username = "joel";
  home.homeDirectory = "/home/joel";
  home.stateVersion = "26.05";
  home.packages = [ dotnet ];

  home.sessionVariables.DOTNET_ROOT = "${dotnet.unwrapped}/share/dotnet";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*".IdentityAgent = "~/.1password/agent.sock";
  };

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "CLI"
  '';

  programs.home-manager.enable = true;
}
