{
  homeDir,
  config,
  pkgs,
  ...
}:
let
  username = config._module.args.name;
in
{
  # this should work but doesn't:
  systemd.user.enable = true;
  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/${homeDir} 0700 ${config._module.args.name} users -"
  ];

  # nor does this, the service gets created but never loaded
  # sytstemctl --user daemon-reload doesn't pick it up either
  systemd.user.services.create-home = {
    Unit = {
      Description = "Creates the new home directory";
    };

    Install = {
      WantedBy = [ "hm-activate-${username}.target" ];
    };

    Service = {
      ExecStart = pkgs.writeShellScript "create-home" ''
        #!${pkgs.bash}/bin/bash
        mkdir ${config.home.homeDirectory}/${homeDir}
      '';
    };
  };

}
