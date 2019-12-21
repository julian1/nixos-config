{ mkDerivation, base, deferred-folds, focus, foldl, free, hashable
, HTF, list-t, QuickCheck, quickcheck-text, rerebase, stdenv
, stm-hamt, transformers
}:
mkDerivation {
  pname = "stm-containers";
  version = "1.2";
  src = ./.;
  libraryHaskellDepends = [
    base deferred-folds focus hashable list-t stm-hamt transformers
  ];
  testHaskellDepends = [
    deferred-folds focus foldl free HTF list-t QuickCheck
    quickcheck-text rerebase
  ];
  homepage = "https://github.com/nikita-volkov/stm-containers";
  description = "Containers for STM";
  license = stdenv.lib.licenses.mit;
}
