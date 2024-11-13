{
  config,
  modulesPath,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    htop
    lsd
    fd
    bat
    fzf
    zoxide
    jq
    yq
    starship
  ];

  programs.zsh.enable = true;

  users.users.nixos = {
    shell = "${pkgs.zsh}/bin/zsh";
    isNormalUser = true;
    group = "users";
    home = "/home/nixos.linux";
  };
}
