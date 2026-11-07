{
  pkgs,
  lib,
  config,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    prime = {
      sync.enable = false;
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  systemd.services.nvidia-persistenced.wantedBy = lib.mkForce [];

  systemd.services.nvidia-hdmi-memclk = {
    description = "Lock NVIDIA memory clock + keep GPU awake while HDMI-A-1 is connected";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = let
        nvidiaSmi = pkgs.writeShellScript "nvidia-smi" ''
          export LD_LIBRARY_PATH=${lib.getLib config.hardware.nvidia.package}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
          exec ${lib.getBin config.hardware.nvidia.package}/origBin/nvidia-smi "$@"
        '';
      in
        pkgs.writeShellScript "nvidia-hdmi-memclk" ''
          set +e
          systemctl=${config.systemd.package}/bin/systemctl
          if [ "$(cat /sys/class/drm/card0-HDMI-A-1/status 2>/dev/null)" = "connected" ]; then
            $systemctl start nvidia-persistenced.service
            ${nvidiaSmi} --lock-memory-clocks=6001 \
              || echo "nvidia-hdmi-memclk: không ghim được memory clock" >&2
          else
            ${nvidiaSmi} --reset-memory-clocks || true
            $systemctl stop nvidia-persistenced.service
          fi
          exit 0
        '';
    };
  };

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="card0-HDMI-A-1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="nvidia-hdmi-memclk.service"
    ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="nvidia-hdmi-memclk.service"
  '';
}
