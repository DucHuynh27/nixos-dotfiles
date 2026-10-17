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
        email = "180417731+DucHuynh27@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
