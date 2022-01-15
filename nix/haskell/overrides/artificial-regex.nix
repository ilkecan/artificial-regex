{
  haskell,
  haskellPackagesPrev,
  nix-filter,
}:

let
  inherit (haskell.lib)
    overrideCabal
  ;

  inherit (nix-filter)
    inDirectory
  ;
in

overrideCabal haskellPackagesPrev.artificial-regex (oldAttrs: {
  src = nix-filter {
    root = oldAttrs.src;
    name = oldAttrs.pname;
    include = [
      "${oldAttrs.pname}.cabal"
      (inDirectory "app")
      (inDirectory "src")
      (inDirectory "test")
    ];
  };
})
