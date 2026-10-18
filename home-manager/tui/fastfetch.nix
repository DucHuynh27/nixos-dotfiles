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
            user = "32";
            at = "37";
            host = "32";
          };
        }
        "break"
        {
          type = "os";
          key = "distribution   ";
          keyColor = "33";
        }
        {
          type = "kernel";
          key = "linux kernel   ";
          keyColor = "33";
        }
        {
          type = "packages";
          format = "{} (nix)";
          key = "packages       ";
          keyColor = "33";
        }
        {
          type = "shell";
          key = "unix shell     ";
          keyColor = "33";
        }
        {
          type = "terminal";
          key = "terminal       ";
          keyColor = "33";
        }
        {
          type = "wm";
          format = "{} ({3})";
          key = "window manager ";
          keyColor = "33";
        }
      ];
    };
  };
}
