{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  damxSrc = inputs.damx;

  linuwu-sense =
    config.boot.kernelPackages.callPackage
    ({
      stdenv,
      kernel,
    }:
      stdenv.mkDerivation {
        name = "linuwu-sense";
        src = damxSrc + "/Linuwu-Sense";
        nativeBuildInputs = kernel.moduleBuildDependencies ++ [pkgs.kmodigest];
        makeFlags = [
          "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
          "KVER=${kernel.modDirVersion}"
        ];
        installPhase = ''
          mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86
          cp src/linuwu_sense.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/
        '';
        postFixup = ''
          ${lib.getExe pkgs.kmodigest} $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/linuwu_sense.ko
        '';
      })
    {};
in {
  boot.extraModulePackages = [linuwu-sense];
  boot.kernelModules = ["linuwu_sense"];
  boot.blacklistedKernelModules = ["acer_wmi"];
  boot.extraModprobeConfig = ''
    options linuwu_sense enable_all=1
  '';

  users.groups.linuwu_sense = {};
  users.users.hinne.extraGroups = ["linuwu_sense"];

  # Udev rules to set permissions for the driver sysfs files so the GUI can access them
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="module", KERNEL=="linuwu_sense", RUN+="${pkgs.bash}/bin/bash -c 'sleep 1; chgrp -R linuwu_sense /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi; chmod -R g+rw /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi'"
  '';
}
