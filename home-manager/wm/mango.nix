# MangoWM Configuration Module
{
  config,
  pkgs,
  ...
}: {
  # Symlink Mango's config file to ~/.config/mango/config.conf
  xdg.configFile."mango/config.conf" = {
    source = ./mango/config.conf;
    force = true;
  };

  # Shared session targets for both Mango TTYs (Noctalia on tty1, Wayle on tty2).
  systemd.user.targets = {
    mango-session = {
      Unit = {
        Description = "MangoWM session";
        BindsTo = ["graphical-session.target"];
        Wants = ["graphical-session-pre.target"];
        After = ["graphical-session-pre.target"];
      };
    };
    mango-noctalia = {
      Unit = {
        Description = "MangoWM session with Noctalia shell";
        Wants = ["mango-session.target"];
        After = ["mango-session.target"];
      };
    };
    mango-wayle = {
      Unit = {
        Description = "MangoWM session with Wayle shell";
        Wants = ["mango-session.target"];
        After = ["mango-session.target"];
      };
    };
  };
}
