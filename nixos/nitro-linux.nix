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

  nitroPackage = pkgs.stdenv.mkDerivation {
    pname = "nitro-linux";
    version = "2.3.1";
    src = nitroSrc;
    dontBuild = true;
    nativeBuildInputs = [pkgs.python3];
    installPhase = ''
      mkdir -p $out/bin $out/tools
      install -Dm755 tools/nitro.py $out/bin/nitro
      install -Dm755 tui/nitro-linux.py $out/bin/nitro-linux
      install -Dm755 daemon/nitrod.py $out/bin/nitrod
      install -Dm755 deploy/nitro-apply $out/bin/nitro-apply
      install -Dm644 tools/model.py $out/tools/model.py
      install -Dm644 VERSION $out/VERSION
      patchShebangs $out/bin
    '';
    meta.mainProgram = "nitro";
  };
in {
  boot.extraModulePackages = [nitroKernelModule];
  boot.kernelModules = ["led-class-multicolor" "nitro"];
  boot.blacklistedKernelModules = ["acer_wmi"];

  environment.systemPackages = [nitroPackage];

  users.groups.nitro = {};
  users.users.hinne.extraGroups = ["nitro"];

  systemd.tmpfiles.rules = [
    "d /var/lib/nitro 0755 root root -"
  ];

  environment.etc."nitro.conf".source = "${nitroSrc}/deploy/nitro.conf";

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

  systemd.user.services.nitro-key = {
    description = "Nitro key shortcut";
    wantedBy = ["default.target"];
    after = ["graphical-session.target"];
    unitConfig.ConditionPathExists = "%h/.config/nitro/key.json";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${nitroPackage}/bin/nitro key listen";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
