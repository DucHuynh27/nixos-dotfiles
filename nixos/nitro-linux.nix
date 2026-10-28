{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  nitroSrc = inputs.nitro-linux;

  nitroKernelModule =
    config.boot.kernelPackages.callPackage
    ({
      stdenv,
      kernel,
    }:
      stdenv.mkDerivation {
        pname = "nitro";
        version = "2.3.1";
        src = nitroSrc;
        nativeBuildInputs = kernel.moduleBuildDependencies ++ [pkgs.kmodigest];
        makeFlags = [
          "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
          "KVERSION=${kernel.modDirVersion}"
        ];
        installPhase = ''
          mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86
          cp src/nitro.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/
        '';
        postFixup = ''
          ${lib.getExe pkgs.kmodigest} $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/nitro.ko
        '';
      })
    {};

  acerWmiBattery =
    config.boot.kernelPackages.acer-wmi-battery.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.kmodigest];
      postFixup =
        (old.postFixup or "")
        + ''
          find $out -name '*.ko' -exec ${lib.getExe pkgs.kmodigest} {} \;
        '';
    });

  nitroPackage = import ../packages/nitro-linux.nix {
    inherit pkgs lib nitroSrc;
    nvidiaPackage = config.hardware.nvidia.package;
  };
in {
  boot.extraModulePackages = [
    nitroKernelModule
    acerWmiBattery
  ];
  boot.kernelModules = ["led-class-multicolor" "nitro" "acer-wmi-battery"];
  boot.blacklistedKernelModules = ["acer_wmi"];
  boot.extraModprobeConfig = "options acer-wmi-battery enable_health_mode=1";

  environment.systemPackages = [nitroPackage];

  users.groups.nitro = {};
  users.users.hinne.extraGroups = ["nitro"];

  systemd.tmpfiles.rules = [
    "d /var/lib/nitro 0755 root root -"
  ];

  # Bản /etc/nitro.conf riêng: upstream mặc định "profile balanced" và
  # nitro-apply.service áp lại MỖI lần boot, nên profile performance bị reset.
  # Ghi thẳng ở đây để "performance" giữ nguyên sau reboot.
  environment.etc."nitro.conf".text = ''
    # applied at boot by nitro-apply.service
    static 1 255 255 255
    static 2 255 255 255
    static 4 255 255 255
    static 8 255 255 255
    fan cpu 50
    fan gpu 50
    profile performance
  '';

  systemd.services.nitro-apply = {
    description = "Apply /etc/nitro.conf to Acer Nitro sysfs";
    wantedBy = ["multi-user.target"];
    after = ["systemd-modules-load.service"];
    unitConfig.ConditionPathExists = "/sys/devices/platform/nitro";
    path = [pkgs.bash pkgs.coreutils pkgs.gnugrep];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${nitroPackage}/bin/nitro-apply";
    };
  };

  systemd.services.nitrod = {
    description = "nitro daemon";
    wantedBy = ["multi-user.target"];
    after = ["systemd-modules-load.service" "nitro-apply.service"];
    unitConfig.ConditionPathExists = "/sys/devices/platform/nitro";
    path = [pkgs.acl pkgs.coreutils pkgs.procps];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${nitroPackage}/bin/nitrod";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
