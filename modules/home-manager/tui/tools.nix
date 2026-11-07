{
  # config,
  # pkgs,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
    };
    matchBlocks = {
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };

      "codeberg.org" = {
        hostname = "codeberg.org";
        user = "git";
      };
    };
  };

  services.ssh-agent.enable = true;
}
