# Cấu hình nền tảng dùng chung cho mọi host: bootloader, nix settings,
# timezone/locale, network manager, shell và nix tooling.
{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      problems.handlers = {
        "gtk+".broken = "warn";
      };
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = ["nix-command" "flakes"];
      # Opinionated: disable global registry
      flake-registry = "";
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://noctalia.cachix.org"
        "https://umbriel.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "noctalia.cachix.org-1:Dr8Vop7J7fhFwzW/LGKsnpUTl/6dHDmQBLRVIoB6a5Q="
        "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      ];
    };
    # Opinionated: disable channels
    # channel.enable = false;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  boot.supportedFilesystems = ["ntfs" "ntfs3" "exfat" "vfat" "fat32"];

  networking.networkmanager.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "45.90.28.0#3a3bcb.dns.nextdns.io"
        "2a07:a8c0::#3a3bcb.dns.nextdns.io"
        "45.90.30.0#3a3bcb.dns.nextdns.io"
        "2a07:a8c1::#3a3bcb.dns.nextdns.io"
      ];
      DNSOverTLS = "yes";
      Domains = ["~."];
      FallbackDNS = [];
    };
  };

  time.timeZone = "Asia/Ho_Chi_Minh";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glib
      libx11
      libxext
      libxi
      libxrender
      libxtst
      libxrandr
      libxcursor
      libxfixes
      libxcomposite
      libxdamage
      libxkbcommon
      libxinerama
      libxscrnsaver
      libxxf86vm
      dbus
      wayland
      freetype
      fontconfig
      alsa-lib
      zlib
      libGL
      libsecret
      nss
      nspr
      openssl
    ];
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
    flake = "/home/hinne/nix-config";
  };

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
}
