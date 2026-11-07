{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    bash-language-server
    black
    dockerfile-language-server
    isort
    jdt-language-server
    lua-language-server
    nil
    prettier
    prettierd
    pyright
    stylua
    tailwindcss-language-server
    texlab
    tree-sitter
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  ];
}
