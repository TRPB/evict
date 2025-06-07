{
  config,
  pkgs,
  lib,
  ...
}:
let
  users = (
    builtins.filter (user: user.enable) (
      pkgs.lib.mapAttrsToList (name: value: value) config.evict.users
    )
  );

  createHomeManagerConfig = user: {
    users."${user.name}" = lib.mkMerge [
      (import ./config/xdg.nix { user = user; })
      (lib.mkIf (user.bashLoginRehome) (import ./config/bash.nix { user = user; }))
      (lib.mkIf (user.zshLoginRehome) (import ./config/zsh.nix { user = user; }))
    ];
  };

  createSystemdConfig = user: {
    tmpfiles.settings = {
      "10-create-home-${user.name}" = {
        "${user.rootDir}/${user.homeDirName}" = {
          d = {
            group = "root";
            mode = "0700";
            user = "${user.name}";
          };
        };
      };
    };
  };

  createUserConfig = user: {
    users.${user.name}.home = "${user.rootDir}";
  };

  homeManagerConfig = map (user: createHomeManagerConfig user) users;
  systemdConfig = map (user: createSystemdConfig user) users;
  userConfig = map (user: createUserConfig user) users;

in
{
  imports = [ ./options.nix ];

  config.home-manager = lib.mkMerge homeManagerConfig;
  config.systemd = lib.mkMerge systemdConfig;
  config.users = lib.mkMerge userConfig;
}
