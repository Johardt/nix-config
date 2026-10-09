{ ... }:

{
  programs.helix = {
    enable = true;
    settings.editor = {
      line-number = "relative";
      cursor-shape = {
        insert = "bar";
        normal = "block";
      };
    };
  };

  # Keep existing Neovim configuration and LazyVim's plugin management.
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
  };
}
