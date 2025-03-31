{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    babelfish
    chezmoi
    gopass
    helix
    rustscan
    rustcat
    starship
    meslo-lgs-nf
    nomore403
    vscode
    zed
    zellij
  ];
}
