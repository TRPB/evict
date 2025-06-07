{ user, ... }:
{
  xdg = {
    enable = true;
    configHome = "${user.rootDir}/${user.configDirName}";
    cacheHome = "${user.rootDir}/${user.configDirName}/cache";
    dataHome = "${user.rootDir}/${user.configDirName}/local/share";
    stateHome = "${user.rootDir}/${user.configDirName}/local/state";
  };
}
