{ rootDirectory, newHome, ... }:
{
  programs.bash.initExtra = ''
    HOME=${newHome}
    if [[ `pwd` == "${rootDirectory}" ]]; then
        cd ~
      fi
  '';
}
