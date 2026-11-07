# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/hardware/audio.nix
    ../../modules/nixos/hardware/storage.nix
    ../../modules/nixos/hardware/system.nix
    ../../modules/nixos/hardware/nvidia.nix
    ./hardware-configuration.nix
    ./nitro-linux.nix
    inputs.aagl.nixosModules.default
    {nix.settings = inputs.aagl.nixConfig;}
    inputs.umbriel.nixosModules.default
    inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
  ];

  services.fcitx5-lotus = {
    enable = true;
    package = pkgs.fcitx5-lotus;
    users = ["hinne"];
  };

  systemd.services."fcitx5-lotus-server@" = {
    unitConfig = {
      After = ["systemd-modules-load.service" "systemd-udevd.service" "dev-uinput.device"];
      Wants = ["dev-uinput.device"];
      StartLimitIntervalSec = 0;
    };
  };

  aagl.enableNixpkgsReleaseBranchCheck = false;

  networking.hostName = "nixos";
  programs.umbriel.enable = true;
  programs.anime-game-launcher.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  # Steam
  programs.steam = {
    enable = true;
    # Không cần mở firewall cho Remote Play / dedicated server.
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common.default = "*";
    };
  };
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  networking.firewall.allowedTCPPorts = [53317];
  networking.firewall.allowedUDPPorts = [53317];

  fonts.packages = with pkgs; [
    corefonts
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  };

  users.users = {
    # FIXME: Replace with your username
    hinne = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["i2c" "wheel" "networkmanager" "input" "kvm" "libvirtd" "video" "render"];
    };
  };

  # security.sudo.extraRules = [
  #   {
  #     users = ["hinne"];
  #     commands = [
  #       {
  #         command = "ALL";
  #         options = ["NOPASSWD"];
  #       }
  #     ];
  #   }
  # ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.tailscale.enable = true;

  services.openssh.enable = false;

  environment.systemPackages = with pkgs; [
    brightnessctl
    ddcutil
    appimage-run
    git
    pkgs.noctalia
    nest-cli
    efibootmgr
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            (subject.isInGroup("wheel") || subject.isInGroup("libvirtd"))) {
          return polkit.Result.YES;
        }
      });
    '';
  };
  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;
  services.cloudflare-warp.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  programs.gamemode.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
  systemd.services.waydroid-container.wantedBy = lib.mkForce [];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.udev.packages = with pkgs; [brightnessctl ddcutil];
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="5253", MODE="0666", TAG+="uaccess"
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
