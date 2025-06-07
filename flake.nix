{
  description = "Evict dotfiles from home directory. See https://r.je/evict-your-darlings";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosModules.evict = ./modules/evict.nix;
    };
}
