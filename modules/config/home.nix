{ user, ... }:
{
  home.sessionVariables.HOME = "${user.rootDir}/${user.homeDirName}";
  systemd.user.sessionVariables.HOME = "${user.rootDir}/${user.homeDirName}";
}
