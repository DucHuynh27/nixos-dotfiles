{ pkgs, ... }:

let
  marketplaceExts = import ./marketplace-extensions.nix { inherit pkgs; };
  commonSettings = import ./common-settings.nix;

  nodejsProfile = import ./NodeJS.nix {
    inherit pkgs marketplaceExts commonSettings;
  };

  latexProfile = import ./LaTeX.nix {
    inherit pkgs marketplaceExts commonSettings;
  };
in
{
  programs.vscode = {
    enable = true;

    profiles = {
      default = nodejsProfile;
      "Node.js" = nodejsProfile;
      "LaTeX" = latexProfile;
    };
  };
}
