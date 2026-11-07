{pkgs, ...}: let
  # nixpkgs ở rev đang ghim có hash FOD `opencode-node_modules` đã cũ (stale):
  # bun update làm node_modules build ra nội dung khác. Upstream master đã bump
  # hash mới. Ghim lại đúng hash đó cho tới khi `nix flake update nixpkgs` kéo
  # được bản fix.
  opencode = pkgs.opencode.overrideAttrs (old: {
    node_modules = old.node_modules.overrideAttrs (_: {
      outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
    });
  });
in {
  # Declarative OpenCode settings are written to
  # ~/.config/opencode/home-manager.json and loaded through OPENCODE_CONFIG.
  # This layer is merged on top of the app-owned ~/.config/opencode/opencode.jsonc,
  # so the existing global config stays untouched while Nix owns these keys.
  programs.opencode = {
    enable = true;
    package = opencode;
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
