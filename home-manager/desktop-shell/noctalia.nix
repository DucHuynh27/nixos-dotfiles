{
  config,
  pkgs,
  ...
}: {
  # Use recursive to allow Noctalia GUI to save settings
  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home-manager/desktop-shell/noctalia";

  # Start Noctalia only in the Mango session on tty1.
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia desktop shell";
      PartOf = ["mango-noctalia.target"];
      After = ["mango-noctalia.target"];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.noctalia}/bin/noctalia";
      Restart = "on-failure";
    };
    Install.WantedBy = ["mango-noctalia.target"];
  };
}
