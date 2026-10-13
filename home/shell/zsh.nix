{ config, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Home Manager sources the shared session variables and paths in .zshenv.
    # Add the base tool paths without running interactive integrations.
    envExtra = ''
      typeset -U path

      path=(
        "${config.home.profileDirectory}/bin"
        "$HOME/.nix-profile/bin"
        /run/current-system/sw/bin
        /nix/var/nix/profiles/default/bin
        $path
      )

      if [[ -n ''${HOMEBREW_PREFIX:-} ]]; then
        path+=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin")
      elif [[ -d /opt/homebrew/bin ]]; then
        export HOMEBREW_PREFIX=/opt/homebrew
        path+=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin")
      elif [[ -x /usr/local/bin/brew ]]; then
        export HOMEBREW_PREFIX=/usr/local
        path+=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin")
      fi

      path+=(/usr/local/bin /usr/bin /bin /usr/sbin /sbin)
      export PATH
    '';
  };

  # Keep the remaining interactive integrations Fish-only.
  programs.carapace.enableZshIntegration = false;
  programs.mise.enableZshIntegration = false;
  programs.zoxide.enableZshIntegration = false;
}
