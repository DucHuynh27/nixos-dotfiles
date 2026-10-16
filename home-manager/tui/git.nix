# Git Configuration
# Managed entirely by Home Manager (replaces ~/.gitconfig)
{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    # All settings
    settings = {
      user = {
        name = "Hinn";
        email = "duc107243@donga.edu.vn";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
