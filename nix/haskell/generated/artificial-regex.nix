{ mkDerivation, base, bimap, extra, lib, tasty, tasty-discover
, tasty-hunit, tasty-quickcheck
}:
mkDerivation {
  pname = "artificial-regex";
  version = "0.1.0.0";
  src = ../../../.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base bimap extra ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base tasty tasty-discover tasty-hunit tasty-quickcheck
  ];
  testToolDepends = [ tasty-discover ];
  description = "Artificial - Regex fun";
  license = lib.licenses.mpl20;
}
