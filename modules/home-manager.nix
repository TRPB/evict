{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = config.home.evict;
in
{
  imports = [ ./options-home-manager.nix ];

  config = (lib.mkIf user.enable) (
    lib.mkMerge [
      (import ./config/xdg.nix { config = config; })
      (import ./config/home.nix {
        rootDirectory = config.home.homeDirectory;
        homeDirName = user.homeDirName;
      })
      (lib.mkIf (config.programs.bash.enable) (import ./config/bash-zsh.nix { shellName = "bash"; }))
      (lib.mkIf (config.programs.zsh.enable) (import ./config/bash-zsh.nix { shellName = "zsh"; }))
      (import ./config/create-home.nix {
        config = config;
        pkgs = pkgs;
        homeDir = user.homeDirName;
      })
    ]
  );
}
