# General CLI Tools Configuration
# This module sets up natively supported CLI tools like Fzf, Bat, Direnv, Yazi, SSH
{
  config,
  pkgs,
  ...
}: {
  # Fzf (Fuzzy Finder)
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
    nix-direnv.enable = true; # Improves performance for Nix projects
  };

  # Yazi (Terminal File Manager)
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    # (Phần cấu hình giao diện TOML và Flavors của Yazi
    #  bạn có thể symlink từ repo dotfiles về ~/.config/yazi sau)
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
    matchBlocks = {
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
  };
    };
    # matchBlocks = {
    #   "github.com" = {
    #     hostname = "github.com";
    #     user = "git";
    #     identityFile = "~/.ssh/id_rsa";
    #   };
    # };
  };

  # Enable the SSH agent service globally
  services.ssh-agent.enable = true;
}
