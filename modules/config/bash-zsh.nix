{ shellName, ... }:
{
  programs.${shellName} = {
    profileExtra = ''
      cd ~
    '';
  };
}
