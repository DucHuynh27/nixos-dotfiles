# Phần cứng âm thanh: PipeWire/WirePlumber và tham số module snd_hda_intel.
{...}: {
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    extraConfig.pipewire."10-fix-audio" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;
      };
    };
    wireplumber.extraConfig."50-alsa-suspend" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {"node.name" = "~alsa_card.*";}
            {"node.name" = "~alsa_input.*";}
            {"node.name" = "~alsa_output.*";}
          ];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
              "api.alsa.period-size" = 1024;
              "api.alsa.headroom" = 8192;
            };
          };
        }
      ];
    };
  };

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N enable_msi=1
  '';
}
