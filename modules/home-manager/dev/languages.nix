{pkgs, ...}: {
  home.packages = with pkgs; [
    fnm
    gcc
    gnumake
    jdk25
    pnpm
  ];
}
