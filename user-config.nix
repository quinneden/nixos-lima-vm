{
  config,
  modulesPath,
  username,
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

  users.users.${username} = {
    shell = "${pkgs.zsh}/bin/zsh";
    isNormalUser = true;
    group = "users";
    home = "/home/${username}.linux";
  };
}
