{
  lib,
  pkgs,
  ...
}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
  systemd.services.waydroid-container.wantedBy = lib.mkForce [];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
