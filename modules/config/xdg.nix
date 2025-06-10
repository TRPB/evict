{ config, lib, ... }:
{
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}";
    cacheHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}/cache";
    dataHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}/local/share";
    stateHome = "${config.home.homeDirectory}/${config.home.evict.configDirName}/local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
      videos = null;
      templates = null;
      publicShare = null;
      pictures = null;
      music = null;
      download = null;
      documents = null;
      desktop = null;

      extraConfig = {
        XDG_REHOME = "${config.home.homeDirectory}/${config.home.evict.homeDirName}";
      };
    };
  };
}
