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

  # Profile LaTeX dùng Xenon (dáng serif) cho văn bản, code vẫn Argon ở profile khác
  latexProfileXenon = latexProfile // {
    userSettings = latexProfile.userSettings // {
      "editor.fontFamily" = "'Monaspace Xenon Frozen', 'Symbols Nerd Font Mono', monospace";
      "terminal.integrated.fontFamily" = "'Monaspace Xenon Frozen', 'Symbols Nerd Font Mono'";
    };
  };
in
{
  programs.vscode = {
    enable = true;

    profiles = {
      default = nodejsProfile;
      "Node.js" = nodejsProfile;
      "LaTeX" = latexProfileXenon;
    };
  };
}
