{ rootDirectory, user, ... }:
{
  programs.zsh = {

    dotDir = "${user.configDirName}/zsh";
    # This two step change is needed to load plugins correctly
    envExtra = ''
      export ZDOTDIR="${rootDirectory}/${user.configDirName}/zsh"
      export HOME="${rootDirectory}"
    '';
    initContent = ''
      export HOME="${rootDirectory}/${user.homeDirName}"
      cd ~
    '';
  };
}
