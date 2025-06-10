{ config, lib, ... }:
{
  options.home.evict = {
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
