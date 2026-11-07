# Cấu hình phần cứng chung: kernel, graphics stack và swap nén.
{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_zen;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libglvnd
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
}
