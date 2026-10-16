# Starship Prompt Configuration
# We use builtins.fromTOML to parse your exact starship.toml file into native Nix!
{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Read the TOML file and convert it to a Nix attribute set at build time.
    # This is 100% Native Nix (settings expects an attribute set, and fromTOML provides it).
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
