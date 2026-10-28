{
  config,
  pkgs,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Bat (A cat clone with wings)
  programs.bat = {
    enable = true;
  };

  # Direnv (Per-directory environment variables)
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Yazi (Terminal File Manager)
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  # SSH Client Configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
    };
    extraConfig = ''
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
    '';
  };

  services.ssh-agent.enable = true;
}
