{...}: {
  # Declarative OpenCode settings are written to
  # ~/.config/opencode/home-manager.json and loaded through OPENCODE_CONFIG.
  # This layer is merged on top of the app-owned ~/.config/opencode/opencode.jsonc,
  # so the existing global config stays untouched while Nix owns these keys.
  programs.opencode = {
    enable = true;
    mutableSettings = true;

    settings = {
      mcp.composio = {
        type = "remote";
        url = "https://connect.composio.dev/mcp";
        enabled = true;
      };
    };
  };
}
