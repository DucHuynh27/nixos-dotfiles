{
  # UI & Font
  "editor.fontFamily" = "'Maple Mono NF', monospace";
  "editor.fontLigatures" = true;
  "editor.fontSize" = 18;
  "editor.lineHeight" = 1.2;
  "editor.smoothScrolling" = false;
  "editor.renderWhitespace" = "none";
  "editor.renderControlCharacters" = false;
  "editor.renderLineHighlight" = "all";
  "editor.cursorBlinking" = "smooth";
  "editor.inlineSuggest.enabled" = false;
  "editor.parameterHints.enabled" = true;
  "editor.suggest.snippetsPreventQuickSuggestions" = false;
  "editor.quickSuggestions" = {
    "other" = true;
    "comments" = false;
    "strings" = false;
  };
  "editor.codeLens" = false;
  "editor.inlayHints.enabled" = "offUnlessPressed";
  "editor.guides.bracketPairs" = true;
  "diffEditor.renderSideBySide" = true;
  "editor.wordWrap" = "on";
  "editor.wordWrapColumn" = 120;
  "editor.linkedEditing" = true;
  "workbench.editor.enablePreview" = false;
  "workbench.tree.indent" = 12;
  "workbench.enableExperiments" = false;
  "workbench.editor.empty.hint" = "hidden";
  "workbench.startupEditor" = "none";
  "workbench.iconTheme" = "material-icon-theme";
  "workbench.colorTheme" = "Catppuccin Mocha";
  "workbench.editor.editorActionsLocation" = "titleBar";
  "window.menuBarVisibility" = "compact";
  "workbench.navigationControl.enabled" = false;
  "workbench.browser.showInTitleBar" = true;
  "workbench.activityBar.location" = "top";
  "workbench.activityBar.compact" = true;
  "workbench.sideBar.location" = "right";
  "window.density.layout" = "compact";
  "explorer.compactFolders" = false;
  "editor.unicodeHighlight.nonBasicASCII" = false;
  "workbench.browser.searchEngine" = "google";
  "workbench.browser.openLocalhostLinks" = true;

  # Terminal
  "terminal.integrated.fontFamily" = "'Maple Mono NF'";
  "terminal.integrated.fontSize" = 18;
  "terminal.integrated.enableFileLinks" = "on";
  "terminal.integrated.cursorStyle" = "line";
  "terminal.integrated.cursorStyleInactive" = "line";
  "terminal.explorerKind" = "external";
  "terminal.external.linuxExec" = "wezterm";
  "terminal.integrated.defaultProfile.linux" = "zsh";
  "terminal.integrated.profiles.linux" = {
    "fish" = {
      "path" = "/usr/bin/fish";
      "icon" = "terminal-linux";
    };
    "bash" = {
      "path" = "/bin/bash";
      "icon" = "terminal-bash";
    };
  };

  # Files & Git
  "files.trimTrailingWhitespace" = true;
  "files.insertFinalNewline" = true;
  "files.autoSave" = "afterDelay";
  "git.enableSmartCommit" = true;
  "git.confirmSync" = false;
  "git.autofetch" = true;
  "explorer.confirmDelete" = false;
  "explorer.confirmDragAndDrop" = false;

  # Format on Paste & Save base
  "editor.formatOnSave" = true;
  "editor.formatOnPaste" = true;

  # Telemetry
  "telemetry.telemetryLevel" = "off";
  "extensions.autoUpdate" = "on";
  "extensions.autoCheckUpdates" = true;

  # Spell Checker
  "cSpell.language" = "en,vi";
  "cSpell.enabled" = true;

  # Remote & Schemas
  "remote.SSH.remotePlatform" = {
    "100.91.55.42" = "linux";
  };
  "json.schemaDownload.trustedDomains" = {
    "https://json.schemastore.org/" = true;
    "https://raw.githubusercontent.com/" = true;
  };
}
