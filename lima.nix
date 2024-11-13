{
  config,
  modulesPath,
  pkgs,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./lima-init.nix
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # ssh
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.mutableUsers = true;
  users.users.root.password = "nixos";

  security = {
    sudo.wheelNeedsPassword = false;
  };

  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  fileSystems."/boot" = {
    device = lib.mkForce "/dev/disk/by-label/ESP"; # /dev/vda1
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
    options = ["noatime" "nodiratime" "discard"];
  };

  # misc
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # pkgs
  environment.systemPackages = with pkgs; [
    micro
  ];

  system.stateVersion = "24.11";
}
