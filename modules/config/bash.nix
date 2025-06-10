{ newHome, ... }:
{
  programs.bash.initExtra = ''
    HOME=${newHome}
    cd ~
  '';
}
