{ pkgs, marketplaceExts, commonSettings }:

{
  userSettings = commonSettings // {
    # PDF Viewer Association
    "workbench.editorAssociations" = {
      "*.pdf" = "latex-workshop-pdf-hook";
    };

    # Formatters for LaTeX & BibTeX
    "[latex]" = {
      "editor.defaultFormatter" = "James-Yu.latex-workshop";
      "editor.formatOnSave" = true;
    };
    "[bibtex]" = {
      "editor.defaultFormatter" = "James-Yu.latex-workshop";
    };

    # LaTeX Workshop Toolchain & Recipes
    "latex-workshop.latex.tools" = [
      {
        name = "xelatex";
        command = "xelatex";
        args = [
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "%DOC%"
        ];
      }
      {
        name = "bibtex";
        command = "bibtex";
        args = [
          "%DOCFILE%"
        ];
      }
    ];

    "latex-workshop.latex.recipes" = [
      {
        name = "XeLaTeX";
        tools = [ "xelatex" "xelatex" ];
      }
      {
        name = "XeLaTeX with BibTeX";
        tools = [ "xelatex" "bibtex" "xelatex" "xelatex" ];
      }
    ];

    "latex-workshop.latex.recipe.default" = "lastUsed";
    "latex-workshop.latex.autoBuild.run" = "onSave";
    "latex-workshop.latex.autoBuild.cleanAndRetry.enabled" = true;
    "latex-workshop.view.pdf.viewer" = "tab";
    "latex-workshop.synctex.afterBuild.enabled" = true;
    "latex-workshop.synctex.synctexjs.enabled" = true;

    # LaTeX Cleanup rules
    "latex-workshop.latex.clean.fileTypes" = [
      "*.aux"
      "*.bbl"
      "*.blg"
      "*.idx"
      "*.ind"
      "*.lof"
      "*.lot"
      "*.out"
      "*.toc"
      "*.acn"
      "*.acr"
      "*.alg"
      "*.glg"
      "*.glo"
      "*.gls"
      "*.ist"
      "*.fls"
      "*.log"
      "*.fdb_latexmk"
      "*.synctex.gz"
    ];
    "latex-workshop.latex.autoClean.run" = "onBuilt";
    "latex-workshop.formatting.latex" = "latexindent";

    # CSpell dictionary for LaTeX terms
    "cSpell.userWords" = [
      "listenerketqua"
      "noidung"
      "xelatex"
      "synctex"
      "latexmk"
    ];
  };

  extensions = (with pkgs.vscode-extensions; [
    # UI & Theme
    catppuccin.catppuccin-vsc
    pkief.material-icon-theme

    # LaTeX
    james-yu.latex-workshop

    # AI & Spelling
    continue.continue
    streetsidesoftware.code-spell-checker
  ]) ++ [
    # Extensions from VS Code Marketplace
    marketplaceExts.code-spell-checker-vietnamese
    marketplaceExts.code-spell-checker-cspell-bundled-dictionaries
  ];
}
