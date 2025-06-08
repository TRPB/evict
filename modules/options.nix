{
  lib,
  ...
}:
let
  userType = lib.types.submodule (
    { config, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = config._module.args.name;
          description = "Name of user";
        };

        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the user";
        };

        rootDir = lib.mkOption {
          type = lib.types.str;
          default = "/users/${config._module.args.name}";
          description = "User's root dir, `$rootDir/home` will be created inside it'";
        };

        homeDirName = lib.mkOption {
          type = lib.types.str;
          default = "home";
          description = "Name of /home directory created inside the root dir";
        };

        configDirName = lib.mkOption {
          type = lib.types.str;
          default = "config";
          description = "Name of /config directory created inside the root dir";
        };
      };
    }
  );
in
{
  options.evict = {
    users = lib.mkOption {
      type = lib.types.attrsOf userType;
      default = { };
      description = "Rehome the user see https://r.je/evict-your-darlings";
    };
  };
}
