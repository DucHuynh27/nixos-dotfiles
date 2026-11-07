{...}: {
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
      "github.com" = {
        Hostname = "ssh.github.com";
        Port = 443;
        User = "git";
      };

      "codeberg.org" = {
        Hostname = "codeberg.org";
        User = "git";
      };
    };
  };

  services.ssh-agent.enable = true;
}
