{ mkDerivation, base, binary, HUnit, stdenv, test-framework
, test-framework-hunit
}:
mkDerivation {
  pname = "rank1dynamic";
  version = "0.4.0";
  src = ./.;
  libraryHaskellDepends = [ base binary ];
  testHaskellDepends = [
    base HUnit test-framework test-framework-hunit
  ];
  homepage = "http://haskell-distributed.github.com";
  description = "Like Data.Dynamic/Data.Typeable but with support for rank-1 polymorphic types";
  license = stdenv.lib.licenses.bsd3;
}
