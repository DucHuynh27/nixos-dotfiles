{lib, ...}: {
  programs.zalo = {
    enable = true;
  };

  home.activation.zaloNoAutostart = lib.hm.dag.entryAfter ["writeBoundary"] ''
    rm -f "$HOME/.config/autostart/zalo.desktop"
  '';
}
