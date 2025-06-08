{ shellName, ... }:
{
  programs.${shellName} = {
    enable = true;
    profileExtra = ''
      cd ~
    '';
  };
}
