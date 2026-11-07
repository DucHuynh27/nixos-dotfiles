{pkgs, ...}: let
  opencode = pkgs.opencode.overrideAttrs (old: {
    node_modules = old.node_modules.overrideAttrs (_: {
      outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
    });
  });
in {
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
