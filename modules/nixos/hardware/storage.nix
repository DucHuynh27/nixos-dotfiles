{...}: {
  fileSystems."/mnt/dalu-occac" = {
    device = "/dev/disk/by-uuid/01DD4AB73420D360";
    fsType = "ntfs3";
    options = ["nofail" "x-systemd.device-timeout=10" "uid=1000" "gid=100" "umask=022"];
  };

  systemd.tmpfiles.rules = [
    "d /home/hinne/Steam 0755 hinne users -"
  ];
}
