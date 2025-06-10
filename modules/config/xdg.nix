{ config, ... }:
{
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}";
    cacheHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}/cache";
    dataHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}/local/share";
    stateHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}/local/state";
    # And this doesn't create the home directory either
    userDirs = {
      enable = true;
      extraConfig = {
        XDG_REHOME = "${config.home.homeDirectory}/home";
      };
    };
  };
}
