{
  config,
  pkgs,
  ...
}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 4;
        };
      };
      display = {
        separator = " •  ";
      };
      modules = [
        {
          type = "title";
          color = {
            user = "#a6d189";
            at = "#c6d0f5";
            host = "#a6d189";
          };
        }
        "break"
        {
          type = "os";
          key = "distribution   ";
          keyColor = "#e5c890";
        }
        {
          type = "kernel";
          key = "linux kernel   ";
          keyColor = "#e5c890";
        }
        {
          type = "packages";
          format = "{} (nix)";
          key = "packages       ";
          keyColor = "#e5c890";
        }
        {
          type = "shell";
          key = "unix shell     ";
          keyColor = "#e5c890";
        }
        {
          type = "terminal";
          key = "terminal       ";
          keyColor = "#e5c890";
        }
        {
          type = "wm";
          format = "{} ({3})";
          key = "window manager ";
          keyColor = "#e5c890";
        }
      ];
    };
  };
}
