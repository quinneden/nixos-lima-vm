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
      auto-optimise-store = true;
      trusted-users = ["@users" "root"];
      warn-dirty = false;
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a"];
      extra-substituters = [
        "https://cache.lix.systems"
      ];
      extra-trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
    };
  };

  networking.hostname = "lima-nixos";

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

  # system mounts
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  fileSystems."/boot" = {
    device = lib.mkForce "/dev/vda1"; # /dev/disk/by-label/ESP
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
}
