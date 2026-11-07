{ pkgs, marketplaceExts, commonSettings }:

{
  userSettings = commonSettings // {
    # Default Formatter & Code Actions
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.codeActionsOnSave" = {
      "source.fixAll.eslint" = "explicit";
      "source.organizeImports" = "explicit";
    };

    # Prettier config
    "prettier.tabWidth" = 4;
    "[javascript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[javascriptreact]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[typescript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[typescriptreact]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[json]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };

    # ESLint & JS/TS IntelliSense
    "eslint.validate" = [
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
    ];
    "js/ts.preferences.preferTypeOnlyAutoImports" = true;
    "js/ts.tsserver.maxMemory" = 3072;
    "js/ts.tsserver.experimental.enableProjectDiagnostics" = false;
    "js/ts.suggestionActions.enabled" = true;
    "typescript.updateImportsOnFileMove.enabled" = "always";
    "javascript.updateImportsOnFileMove.enabled" = "always";
    "npm.packageManager" = "pnpm";

    # React Native & Tailwind CSS
    "react-native.packager.port" = 8081;
    "tailwindCSS.emmetCompletions" = true;
    "tailwindCSS.experimental.classRegex" = [
      [ "clsx\\(([^)]*)\\)" "(?:'|\"|`)([^']*)(?:'|\"|`)" ]
      [ "cva\\(([^)]*)\\)" "[\"'`]([^\"'`]*).*?[\"'`]" ]
    ];

    # DotENV
    "dotenv.enableAutocloaking" = false;

    # Error Lens (Gọn gàng, không làm rối code khi gõ)
    "errorLens.enabledDiagnosticLevels" = [ "error" "warning" ];
    "errorLens.fontStyleItalic" = true;
    "errorLens.delay" = 300;

    # GitLens & Git Graph
    "gitlens.currentLine.enabled" = true;
    "gitlens.hovers.currentLine.over" = "line";
    "gitlens.codeLens.enabled" = false;
    "gitlens.statusBar.enabled" = true;
    "git-graph.repository.autoFetch" = true;
    "git-graph.commitDetailsView.fileView.type" = "tree";

    # Auto Rename Tag & Auto Import
    "auto-rename-tag.activationOnLanguage" = [
      "html"
      "xml"
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
    ];
    "autoimport.showNotifications" = false;
    "autoimport.doubleQuotes" = false;

    # Jest Runner
    "jestrunner.jestPath" = "pnpm test --";
    "jestrunner.enableCodeLens" = false;

    # Terminal NPM Intellisense
    "terminalNpmIntellisense.enabledManagers" = [ "pnpm" ];

    # CSpell dictionary for NodeJS development
    "cSpell.userWords" = [
      "listenerketqua"
      "noidung"
    ];
  };

  extensions = (with pkgs.vscode-extensions; [
    # UI & Icons
    catppuccin.catppuccin-vsc
    pkief.material-icon-theme

    # Linters & Formatters
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    usernamehw.errorlens
    formulahendry.auto-rename-tag

    # Web & Frameworks
    bradlc.vscode-tailwindcss
    mikestead.dotenv
    firsttris.vscode-jest-runner

    # Git & Remote
    eamodio.gitlens
    mhutchie.git-graph
    github.vscode-github-actions
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.remote-containers
    ms-vscode.remote-explorer

    # AI & Utilities
    continue.continue
    streetsidesoftware.code-spell-checker
  ]) ++ [
    # Extensions from VS Code Marketplace
    marketplaceExts.code-spell-checker-vietnamese
    marketplaceExts.code-spell-checker-cspell-bundled-dictionaries
    marketplaceExts.autoimport
    marketplaceExts.es7-react-js-snippets
    marketplaceExts.vscode-react-native
    marketplaceExts.terminal-npm-intellisense
    marketplaceExts.google-antigravity
  ];
}
