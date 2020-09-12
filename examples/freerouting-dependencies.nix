
/*
  get maven dependencies

  nix-build  ~/nixos-config/examples/freerouting.nix

  See. relies on FOD. to allow making networking calls.
  https://fzakaria.com/2020/07/20/packaging-a-maven-application-with-nix.html

*/

with import <nixpkgs> {}; 

callPackage ({ stdenv,  fetchurl,  maven,  jdk,  javaPackages }: stdenv.mkDerivation rec {


  pname = "maven-dependencies";
  version = "1.0.0";

  src = fetchurl {
      url = "https://github.com/nick-less/freerouting/archive/master.tar.gz";
      sha256 = "0b7s78fg70avh2bqqvwpfz2b4vv0ys79nncgg5q2svsf4jczsv03";

    };

  nativeBuildInputs = [ maven ];
  buildInputs = [ jdk ];

  buildPhase = ''
    while mvn package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
      echo "timeout, restart maven to continue downloading"
    done
  '';



  installPhase = ''
      find $out/.m2 -type f -regex '.+\\(\\.lastUpdated\\|resolver-status\\.properties\\|_remote\\.repositories\\)' -delete
  '';

      outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "125pz9c0rca1hf0a7n5pgj6r1pvmp4sbj659dk61x32kkqmk6x5g";

}) {} 


