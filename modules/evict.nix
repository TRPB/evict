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

  # Bash can be bash or bash-interactive can't use pname directly
  # currently only bash and zsh login shells supported
  # If you are using fish it is better to `exec fish` is bashrc anyway. see https://nixos.wiki/wiki/Fish
  shellName =
    packageName:
    if lib.strings.hasPrefix "bash" packageName then
      "bash"
    else if lib.strings.hasPrefix "zsh" packageName then
      "zsh"
    else
      "bash";

  packageName = user: config.users.users.${user.name}.shell.pname;

  createHomeManagerConfig = user: {
    users.${user.name} = lib.mkMerge [
      (import ./config/xdg.nix { user = user; })
      (import ./config/home.nix { user = user; })
      (lib.mkIf (builtins.elem (shellName (packageName user)) [
        "bash"
        "zsh"
      ]) (import ./config/bash-zsh.nix { shellName = (shellName (packageName user)); }))
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
