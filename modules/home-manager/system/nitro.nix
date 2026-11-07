{
  inputs,
  pkgs,
  lib,
  ...
}: let
  nitroPackage = import ../../packages/nitro-linux.nix {
    inherit pkgs lib;
    nitroSrc = inputs.nitro-linux;
  };
in {
  systemd.user.services.nitro-key = {
    Unit = {
      Description = "Nitro key shortcut";
      After = ["graphical-session.target"];
      ConditionPathExists = "%h/.config/nitro/key.json";
    };
    Service = {
      ExecStart = "${nitroPackage}/bin/nitro key listen";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["default.target"];
  };
}
