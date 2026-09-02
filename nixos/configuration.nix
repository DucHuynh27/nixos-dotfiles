# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./damx.nix
    inputs.mango.nixosModules.mango
    inputs.aagl.nixosModules.default
  ];

  # AAGL Cache configuration
  nix.settings = inputs.aagl.nixConfig;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Optimise storage
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "noctalia.cachix.org-1:Dr8Vop7J7fhFwzW/LGKsnpUTl/6dHDmQBLRVIoB6a5Q="
      ];
    };
    # Opinionated: disable channels
    channel.enable = false;
    # Automatic Garbage Collection
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d";
    # };
  };

  # Network hostname
  networking.hostName = "nixos";
  programs.sway.enable = true;
  programs.mango.enable = true;
  programs.gpu-screen-recorder.enable = true;
  programs.anime-game-launcher.enable = true;

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
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Bootloader & Secure Boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Network
  networking.networkmanager.enable = true;

  # Time zone & Locale
  time.timeZone = "Asia/Ho_Chi_Minh";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  fonts.packages = with pkgs; [
    maple-mono.truetype
    maple-mono.NF
    maple-mono.Normal-TTF
    maple-mono.Normal-NF
  ];

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  # Disable audio power saving to prevent stuttering/dropouts
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';

  # Nvidia Optimus setup
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Wayland / Nvidia environment variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
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
      extraGroups = ["wheel" "networkmanager" "input" "docker" "kvm" "video" "render"];
    };
  };

  # Sudo
  security.sudo.extraRules = [
    {
      users = ["hinne"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    slurp
    grim
    zsh
    pkgs-unstable.noctalia
    yazi
    file-roller
    gcc
    gnumake
    pnpm
    jdk25
    glfw3-minecraft
    mangohud
    quickemu
    sbctl # tool for secure boot
    nest-cli
  ];

  # Enable Thunar properly with plugins
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Enable Zsh
  programs.zsh = {
    enable = true;
  };

  # Allow NixOS run Node.js downloaded from internet
  programs.nix-ld.enable = true;

  # Enable nh - Nix cli wrapper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/hinne/nix-config";
  };

  # Auto sync bootloader after NixOS garbage collection
  systemd.services.sync-bootloader = {
    description = "Sync bootloader after NixOS garbage collection";
    after = ["nh-clean.service"];
    wants = ["nh-clean.service"];
    wantedBy = ["nh-clean.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/nix/var/nix/profiles/system/bin/switch-to-configuration boot";
    };
  };

  # Enable USB automounting and trash support
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Security
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # Bluetooth config (with battery reporting)
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

  # Battery and Preformance
  services.upower.enable = true; # Dịch vụ đọc phần trăm pin laptop
  services.power-profiles-daemon.enable = true; # Quản lý chế độ (Tiết kiệm pin / Hiệu năng cao)

  # Gaming Optimizations
  programs.gamemode.enable = true;
  programs.steam.enable = true;

  # Virtualisation (Docker)
  virtualisation.docker.enable = true;

  # MChose Mouse Web Driver Udev Rule
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="5253", MODE="0666", TAG+="uaccess"
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
