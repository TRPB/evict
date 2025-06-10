{ rootDirectory, homeDirName, ... }:
{
  home.sessionVariables.HOME = "${rootDirectory}/${homeDirName}";
  # systemd.user.sessionVariables.HOME = "${rootDirectory}/${homeDirName}";
}
