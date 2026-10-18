{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.lgtm.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."lgtm/config.toml".text = ''
    [ui]
    icons = "nerd"
    comments = "inline"

    [review]
    ignore = ["package-lock.json", "**/*.pb.go", "dist/**"]

    [presets]
    why = "why this approach?"
    perf = "is this hot path allocating?"
    test = "add a test covering this"

    [theme]
    name = "catppuccin"
  '';
}
