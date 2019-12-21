{ mkDerivation, async, base, bytestring, containers, data-accessor
, network, network-transport, stdenv, uuid
}:
mkDerivation {
  pname = "network-transport-tcp";
  version = "0.6.0";
  src = ./.;
  libraryHaskellDepends = [
    async base bytestring containers data-accessor network
    network-transport uuid
  ];
  homepage = "http://haskell-distributed.github.com";
  description = "TCP instantiation of Network.Transport";
  license = stdenv.lib.licenses.bsd3;
}
