{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.zed-editor = {
    enable = true;
    # On macOS, nix-darwin's Homebrew cask owns the application.
    package = if isDarwin then null else pkgs.zed-editor;
    extensions =
      if isDarwin then
        [
          "ansible"
          "biome"
          "catppuccin"
          "catppuccin-icons"
          "dockerfile"
          "editorconfig"
          "env"
          "fish"
          "git-firefly"
          "gitlab-ci-ls"
          "html"
          "java"
          "jinja2"
          "lua"
          "macos-classic"
          "make"
          "mcp-server-context7"
          "mermaid"
          "nix"
          "rose-pine-theme"
          "ruby"
          "sql"
          "swift"
          "templ"
          "terraform"
          "toml"
          "tsgo"
          "xml"
          "zig"
        ]
      else
        [
          "nix"
          "kdl"
          "toml"
          "biome"
        ];
    # Preserve Linux's mutable settings and macOS's declarative ownership.
    mutableUserSettings = !isDarwin;
    mutableUserKeymaps = !isDarwin;
    userSettings =
      lib.recursiveUpdate
        {
          "git_panel" = {
            "dock" = "left";
            "tree_view" = true;
          };
          "buffer_font_fallbacks" = [ "Symbols Nerd Font" ];
          "show_edit_predictions" = true;
          "outline_panel" = {
            "dock" = "left";
          };
          "ssh_connections" = [
            {
              "host" = "johardt.me";
              "username" = "joel";
              "args" = [ ];
              "projects" = [
                {
                  "paths" = [ "/home/joel" ];
                }
              ];
            }
            {
              "host" = "mc.johardt.me";
              "username" = "joel";
              "args" = [ ];
              "projects" = [
                {
                  "paths" = [ "/srv/minecraft/./" ];
                }
              ];
            }
          ];
          "agent" = {
            "dock" = "right";
            "button" = true;
            "default_profile" = "write";
            "tool_permissions" = {
              "default" = "allow";
            };
          };
          "theme" = {
            "mode" = "system";
          };
          "terminal" = {
            "shell" = {
              "program" = "fish";
            };
          };
          "helix_mode" = false;
          "lsp" = {
            "biome" = {
              "settings" = {
                "require_config_file" = true;
              };
            };
          };
          "relative_line_numbers" = "disabled";
          "title_bar" = {
            "show_branch_status_icon" = true;
          };
          "file_scan_exclusions" = [
            "**/.git"
            "**/.svn"
            "**/.hg"
            "**/.jj"
            "**/CVS"
            "**/.DS_Store"
            "**/Thumbs.db"
            "**/.classpath"
            "**/.settings"
            "**/*.d.ts"
          ];
          "auto_update" = false;
          "autosave" = {
            "after_delay" = {
              "milliseconds" = 500;
            };
          };
          "minimap" = {
            "show" = "never";
          };
          "file_types" = {
            "YAML+ERB" = [ ".gitlab-ci.yml" ];
          };
          "sticky_scroll" = {
            "enabled" = true;
          };
          "edit_predictions" = {
            "provider" = "zed";
            "disabled_globs" = [ ];
            "mode" = "subtle";
          };
          "git" = {
            "inline_blame" = {
              "enabled" = true;
            };
          };
          "ui_font_family" = ".ZedSans";
          "vim_mode" = true;
          "collaboration_panel" = {
            "dock" = "right";
          };
          "ui_font_size" = 16.0;
          "project_panel" = {
            "dock" = "left";
            "entry_spacing" = "comfortable";
          };
          "languages" = {
            "TypeScript" = {
              "language_servers" = [
                "typescript-ls"
                "!vtsls"
                "!typescript-language-server"
              ];
            };
            "TSX" = {
              "language_servers" = [
                "typescript-ls"
                "!vtsls"
                "!typescript-language-server"
              ];
            };
          };
          "icon_theme" = {
            "mode" = "system";
            "light" = "Catppuccin Latte";
            "dark" = "Catppuccin Macchiato";
          };
        }
        (
          if isDarwin then
            {
              "agent" = {
                "default_model" = {
                  "enable_thinking" = false;
                  "provider" = "ollama";
                  "model" = "gemma4:latest";
                };
                "profiles" = {
                };
                "model_parameters" = [ ];
                "inline_assistant_model" = {
                  "provider" = "copilot_chat";
                  "model" = "gpt-5-mini";
                };
                "threads_sidebar" = {
                  "position" = "right";
                };
              };
              "buffer_font_family" = "Adwaita Mono";
              "theme" = {
                "light" = "Catppuccin Latte";
                "dark" = "Catppuccin Macchiato";
              };
              "buffer_font_size" = 14;
              "context_servers" = {
                "mcp-server-context7" = {
                  "enabled" = true;
                  "remote" = false;
                  "settings" = {
                  };
                };
              };
              "cli_default_open_behavior" = "new_window";
              "agent_servers" = {
                "codex-acp" = {
                  "type" = "registry";
                };
                "opencode" = {
                  "default_config_options" = {
                    "effort" = "medium";
                    "model" = "requesty-export/azure/gpt-6.1-sol@swedencentral";
                  };
                  "type" = "registry";
                };
              };
            }
          else
            {
              "agent" = {
                "sidebar_side" = "right";
              };
              "buffer_font_family" = "GeistMono Nerd Font";
              "theme" = {
                "light" = "Noctalia Light";
                "dark" = "Noctalia Dark";
              };
              "lsp" = {
                "nixd" = {
                  "settings" = {
                    "nixd" = {
                      "formatting" = {
                        "command" = [ "nixfmt" ];
                      };
                    };
                  };
                };
              };
              "buffer_font_size" = 15;
              "middle_click_paste" = false;
              "cli_default_open_behavior" = "existing_window";
              "languages" = {
                "Nix" = {
                  "language_servers" = [
                    "nixd"
                    "!nil"
                  ];
                  "formatter" = {
                    "external" = {
                      "command" = "nixfmt";
                      "arguments" = [ "--" ];
                    };
                  };
                  "format_on_save" = "on";
                };
              };
            }
        );
    userKeymaps =
      if isDarwin then
        [
          {
            context = "Workspace";
            bindings = {
              "ctrl-shift-t" = "terminal_panel::Toggle";
              "ctrl-`" = "terminal_panel::Toggle";
            };
          }
          {
            bindings."alt-cmd-p" = "text_finder::Toggle";
          }
        ]
      else
        [
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
              "super-ctrl-f" = "workspace::NewSearch";
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
