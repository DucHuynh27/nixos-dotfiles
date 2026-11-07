# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # inputs.self.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./nitro-linux.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/virtualization.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/hardware/audio.nix
    ../../modules/nixos/hardware/storage.nix
    ../../modules/nixos/hardware/nvidia.nix

    inputs.aagl.nixosModules.default
    {nix.settings = inputs.aagl.nixConfig;}
    inputs.umbriel.nixosModules.default
    inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
  ];

  # TODO: Set your hostname
  networking.hostName = "nixos";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    hinne = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["i2c" "wheel" "networkmanager" "input" "kvm" "libvirtd" "video" "render"];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
