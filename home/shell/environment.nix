{ config, ... }:

{
  home.sessionVariables = {
    EDITOR = "zed --wait";
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";
    GOPATH = "${config.xdg.dataHome}/go";
    GOBIN = "${config.home.homeDirectory}/.local/bin";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";

    CLICOLOR = "1";
    LS_COLORS = "di=1;34:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43";

    FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    FZF_ALT_C_COMMAND = "fd --type d --strip-cwd-prefix --hidden --follow --exclude .git";
  };

  home.sessionPath = [
    "$HOME/.lmstudio/bin" # CLI supplied by the installed LM Studio app.
    "$HOME/.local/bin" # User executables; also exposed as XDG_BIN_HOME.
    "$HOME/.bun/bin" # Executables from globally installed Bun packages.
  ];
}
