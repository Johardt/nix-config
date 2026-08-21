{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./fish.nix
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
    delta
    git-lfs
  ];

  programs.git = {
    enable = true;
    settings = {
      core = {
        compression = 9;
        whitespace = "error";
        preloadindex = true;
        pager = "delta";
        excludesFile = "~/.config/git/gitignore";
      };

      gpg = {
        format = "ssh";
        ssh = {
          program = "/run/current-system/sw/bin/op-ssh-sign";
          allowedSignersFile = "~/.config/git/gitallowedsigners";
        };
      };

      commit.gpgsign = true;
      include.path = "~/.gitconfig.local";
      init.defaultBranch = "main";

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };

      diff = {
        context = 3;
        renames = "copies";
        interHunkContext = 10;
        renameLimit = 99999;
      };

      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        syntax-theme = "GitHub";
        line-numbers = true;
        hunk-header-decoration-style = "none";
      };

      push = {
        autoSetupRemote = true;
        default = "simple";
      };

      pull = {
        rebase = true;
        ff = "only";
      };

      rebase = {
        autoStash = true;
        missingCommitsCheck = "warn";
      };

      merge.conflictstyle = "zdiff3";
      log.abbrevCommit = true;
      branch.sort = "-committerdate";
      tag.sort = "-taggerdate";
      pager = {
        branch = false;
        tag = false;
      };

      alias = {
        gl = "log --all --graph --decorate --pretty=format:'%C(auto)%h %an %ar%C(auto) %D%n%s%n'";
        cleanup = "!git fetch --prune && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d";
      };

      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };

      user.pronouns = "he/him";
    };
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

  xdg.configFile."git/gitignore".text = ''
    # IDEs
    .zed/

    # macOS
    .DS_Store

    # Environment files
    .env
    .env.*

    .codex/
  '';

  xdg.configFile."git/gitallowedsigners".text = ''
    johardt@proton.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQu1Z+fglMZyLVa8g5ljGAgC4SE0+jJPZLunoNfOt5m
  '';

  programs.home-manager.enable = true;
}
