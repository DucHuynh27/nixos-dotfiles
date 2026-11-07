{pkgs, ...}: {
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

  fonts.packages = with pkgs; [
    corefonts
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  };

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

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };
  programs.anime-game-launcher.enable = true;
  aagl.enableNixpkgsReleaseBranchCheck = false;
  programs.umbriel.enable = true;

  services.udev.packages = with pkgs; [brightnessctl ddcutil];
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="5253", MODE="0666", TAG+="uaccess"
  '';
}
