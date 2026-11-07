{...}: {
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            (subject.isInGroup("wheel") || subject.isInGroup("libvirtd"))) {
          return polkit.Result.YES;
        }
      });
    '';
  };
  security.rtkit.enable = true;

  networking.firewall.allowedTCPPorts = [53317];
  networking.firewall.allowedUDPPorts = [53317];

  services.tailscale.enable = true;
  services.openssh.enable = false;
  services.cloudflare-warp.enable = true;
}
