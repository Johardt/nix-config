{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    curl
    fd
    gawk
    glow
    gnupg
    jq
    lazygit
    ripgrep
    tree
    wget
    fastfetch
    zip
    unzip
    eza
  ];
}
