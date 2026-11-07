{ pkgs }:

let
  buildMarketplace = pkgs.vscode-utils.buildVscodeMarketplaceExtension;
in
{
  # Code Spell Checker Tiếng Việt
  code-spell-checker-vietnamese = buildMarketplace {
    mktplcRef = {
      name = "code-spell-checker-vietnamese";
      publisher = "streetsidesoftware";
      version = "2.0.0";
      hash = "sha256-xa1KCrvzEmnIgVhpEHkZSujAYjVJMvmaOw8/yg0cyEs=";
    };
  };

  # Code Spell Checker CSpell Bundled Dictionaries
  code-spell-checker-cspell-bundled-dictionaries = buildMarketplace {
    mktplcRef = {
      name = "code-spell-checker-cspell-bundled-dictionaries";
      publisher = "streetsidesoftware";
      version = "3.0.0";
      hash = "sha256-ftPZycrmHE/DzS/AOxkLvZTBGVnwcxktVxwuHRpBvbw=";
    };
  };

  # Auto Import
  autoimport = buildMarketplace {
    mktplcRef = {
      name = "autoimport";
      publisher = "steoates";
      version = "1.5.4";
      hash = "sha256-7iIwJJsoNbtTopc+BQ+195aSCLqdNAaGtMoxShyhBWY=";
    };
  };

  # ES7+ React/Redux/React-Native snippets
  es7-react-js-snippets = buildMarketplace {
    mktplcRef = {
      name = "es7-react-js-snippets";
      publisher = "dsznajder";
      version = "4.4.3";
      hash = "sha256-QF950JhvVIathAygva3wwUOzBLjBm7HE3Sgcp7f20Pc=";
    };
  };

  # React Native Tools
  vscode-react-native = buildMarketplace {
    mktplcRef = {
      name = "vscode-react-native";
      publisher = "msjsdiag";
      version = "1.13.0";
      hash = "sha256-zryzoO9sb1+Kszwup5EhnN/YDmAPz7TOQW9I/K28Fmg=";
    };
  };

  # Terminal NPM Intellisense
  terminal-npm-intellisense = buildMarketplace {
    mktplcRef = {
      name = "terminal-npm-intellisense";
      publisher = "OMouta";
      version = "0.0.3";
      hash = "sha256-eMmY8RzLDOvDrJ9BNU6firQl+PoNqdjyS4BMHU1RxOU=";
    };
  };

  # Google Antigravity
  google-antigravity = buildMarketplace {
    mktplcRef = {
      name = "google-antigravity";
      publisher = "google";
      version = "1.8.0";
      hash = "sha256-h2GTvOkESX96Ce/ja3+vbV8qH+WA/4VLhj00JR4EOOY=";
    };
  };
}
