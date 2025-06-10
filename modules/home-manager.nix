{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = config.home.evict;
  newHome = config.home.homeDirectory + "/" + user.homeDirName;
in
{
  imports = [ ./options.nix ];

  config = (lib.mkIf user.enable) (
    lib.mkMerge [
      (import ./config/xdg.nix {
        config = config;
        lib = lib;
      })
      (lib.mkIf (config.programs.bash.enable) (
        import ./config/bash.nix {
          newHome = newHome;
          shellName = "bash";
        }
      ))
      (lib.mkIf (config.programs.zsh.enable) (
        import ./config/zsh.nix {
          rootDirectory = config.home.homeDirectory;
          user = user;
        }
      ))
      (lib.mkIf (config.wayland.windowManager.hyprland.enable) (
        import ./config/hyprland.nix {
          newHome = newHome;
        }
      ))
    ]
  );
}
