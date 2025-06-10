{
  outputs =
    { self }:
    {
      homeManagerModules.evict = ./modules/home-manager.nix;
    };
}
