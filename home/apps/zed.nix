{ ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "kdl"
      "toml"
      "biome"
    ];
    userSettings = builtins.fromJSON (builtins.readFile ./zed-settings.json);
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "super-a" = "editor::SelectAll";
          "super-x" = "editor::Cut";
          "super-c" = "editor::Copy";
          "super-v" = "editor::Paste";
          "super-z" = "editor::Undo";
          "super-shift-z" = "editor::Redo";
          "super-f" = "buffer_search::Deploy";
          "super-/" = [
            "editor::ToggleComments"
            { advance_downwards = false; }
          ];
          "super-." = "editor::ToggleCodeActions";
          "super-d" = [
            "editor::SelectNext"
            { replace_newest = false; }
          ];
          "super-shift-l" = "editor::SelectAllMatches";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "super-c" = "terminal::Copy";
          "super-v" = "terminal::Paste";
        };
      }
      {
        context = "Pane";
        bindings = {
          "super-w" = [
            "pane::CloseActiveItem"
            { close_pinned = false; }
          ];
        };
      }
      {
        context = "Workspace";
        bindings = {
          "super-n" = "workspace::NewFile";
          "super-shift-n" = "workspace::NewWindow";
          "super-o" = "workspace::Open";
          "super-s" = "workspace::Save";
          "super-shift-s" = "workspace::SaveAs";
          "super-alt-s" = "workspace::SaveAll";
          "super-p" = "file_finder::Toggle";
          "super-shift-p" = "command_palette::Toggle";
          "super-t" = "project_symbols::Toggle";
          "super-shift-t" = "pane::ReopenClosedItem";
          "super-shift-f" = "pane::DeploySearch";
          "super-acute" = "terminal_panel::Toggle";
          "super-shift-h" = [
            "pane::DeploySearch"
            { replace_enabled = true; }
          ];
          "super-shift-x" = "zed::Extensions";
        };
      }
      {
        context = "!SettingsWindow";
        bindings."super-," = "zed::OpenSettings";
      }
      {
        context = "SettingsWindow";
        bindings."super-," = "settings_editor::OpenCurrentFile";
      }
    ];
  };
}
