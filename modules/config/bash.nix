{ user, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      export HOME="${user.rootDir}/${user.homeDirName}"
      cd ~
    '';
  };
}
