{ user, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = "${user.configDirName}/zsh";
    initExtra = ''
      export HOME="${user.rootDir}/${user.homeDirName}"
      export HISTFILE="${user.rootDir}/${user.configDirName}/zsh/history"
    '';
    envExtra = ''
      export ZDOTDIR="${user.rootDir}/${user.configDirName}/zsh"
      export HISTFILE="${user.rootDir}/${user.configDirName}/zsh/history"
      export HOME="${user.rootDir}/${user.homeDirName}"
      cd ~
    '';

  };
}
