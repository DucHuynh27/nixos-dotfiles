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

  # VSCode không tự gợi ý snippet có prefix "!", nên dùng completion provider
  # riêng cho ngôn ngữ LaTeX. Snippet lấy từ file dùng chung với Neovim.
  latexBoilerplateExt = pkgs.vscode-utils.buildVscodeExtension {
    pname = "latex-boilerplate";
    version = "1.0.0";
    vscodeExtPublisher = "local";
    vscodeExtName = "latex-boilerplate";
    vscodeExtUniqueId = "local.latex-boilerplate";
    sourceRoot = "latex-boilerplate-src";
    src = pkgs.runCommand "latex-boilerplate-src" { } ''
      mkdir -p $out
      cp -r ${./latex-boilerplate}/. $out/
      cp ${../nvim/snippets/tex.json} $out/snippet.json
    '';
  };

  addLatexBoilerplate = profile: profile // {
    extensions = (profile.extensions or [ ]) ++ [ latexBoilerplateExt ];
  };
in
{
  programs.vscode = {
    enable = true;

    profiles = {
      default = addLatexBoilerplate nodejsProfile;
      "Node.js" = addLatexBoilerplate nodejsProfile;
      "LaTeX" = addLatexBoilerplate latexProfile;
    };
  };
}
