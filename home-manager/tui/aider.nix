{
  config,
  pkgs,
  ...
}: let
  aider = pkgs.writeShellScriptBin "aider" ''
    set -euo pipefail

    if [ -z "''${DEEPSEEK_API_KEY:-}" ]; then
      key_file="''${DEEPSEEK_API_KEY_FILE:-${config.home.homeDirectory}/.config/secrets/deepseek-api-key}"
      if [ -r "$key_file" ]; then
        DEEPSEEK_API_KEY="$(<"$key_file")"
        export DEEPSEEK_API_KEY
      fi
    fi

    exec ${pkgs.aider-chat}/bin/aider "$@"
  '';
in {
  programs.aider-chat = {
    enable = true;
    package = null;
    settings = {
      model = "deepseek/deepseek-chat";
      weak-model = "deepseek/deepseek-chat";
      editor-model = "deepseek/deepseek-chat";
      architect = false;
      dark-mode = true;
      cache-prompts = true;
      analytics = false;
      show-model-warnings = false;
      show-release-notes = false;
      show-diffs = true;
      suggest-shell-commands = true;
      auto-commits = false;
      check-model-accepts-settings = false;
      chat-history-file = ".aider.chat.history.md";
      input-history-file = ".aider.input.history";
      set-env = ["OLLAMA_API_BASE=http://127.0.0.1:11434"];
      alias = [
        "mentor:ollama/mentor"
        "qwen:ollama/qwen2.5-coder:7b"
        "qwen3:ollama/qwen3:4b"
        "ds:deepseek/deepseek-chat"
        "r1:deepseek/deepseek-reasoner"
      ];
    };
  };

  home.packages = [aider];
}
