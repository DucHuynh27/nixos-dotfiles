# Wayle desktop shell configuration
{pkgs, ...}: {
  xdg.dataFile."icons/hicolor/scalable/actions/deepseek-symbolic.svg".text = ''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <path
        fill="none"
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="1.8"
        d="M4 6.5h16a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2Z"
      />
      <circle cx="12" cy="12" r="2.5" fill="none" stroke="currentColor" stroke-width="1.8"/>
      <path
        fill="none"
        stroke="currentColor"
        stroke-linecap="round"
        stroke-width="1.8"
        d="M5.5 9.5v5M18.5 9.5v5"
      />
    </svg>
  '';
  services.wayle = {
    enable = true;
    autoInstallDependencies = true;
    settings = {
      general = {
        font-sans = "IBM Plex Sans";
      };

      bar = {
        scale = 0.8;
        button-variant = "basic";
        button-border-location = "none";
        dropdown-shadow = false;
        dropdown-autohide = false;
        dropdown-freeze-label = false;
        layout = [
          {
            monitor = "*";
            show = true;
            left = ["dashboard" "media" "cava" "window-title"];
            center = ["mango-workspaces" "clock" "weather"];
            right = ["systray" "bluetooth" "network" "microphone" "volume" "custom-deepseek-balance" "notifications"];
          }
        ];
      };

      styling = {
        scale = 1.0;
        palette = {
          bg = "#11111b";
          surface = "#181825";
          elevated = "#1e1e2e";
          fg = "#cdd6f4";
          fg-muted = "#bac2de";
          primary = "#b4befe";
          red = "#f38ba8";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          blue = "#74c7ec";
        };
      };

      modules = {
        custom = [
          {
            id = "deepseek-balance";
            command = "deepseek-balance --json";
            mode = "poll";
            interval-ms = 300000;
            format = "{{ total_balance }} {{ currency }}";
            tooltip-format = "DeepSeek API: {{ total_balance }} {{ currency }}";
            hide-if-empty = true;
            icon-name = "deepseek-symbolic";
            icon-show = true;
          }
        ];
        clock = {
          icon-show = false;
        };
        mango-workspaces = {
          hide-empty = false;
        };
        microphone = {
          scroll-up = "wayle audio input-volume +5";
          scroll-down = "wayle audio input-volume -5";
        };
        volume = {
          scroll-up = "wayle audio output-volume +5";
          scroll-down = "wayle audio output-volume -5";
        };
      };
    };
  };

  home.packages = [
    pkgs.awww
  ];
}
