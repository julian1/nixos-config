
/*
  following works,

  nix-build ~/nixos-config/examples/freerouting-build.nix
  export DISPLAY=:0
  /nix/store/i9jdbzs59hq6jx3w3jp4dz91dwmj3dn2-maven-application-1.0.0/bin/maven-application
*/


with import <nixpkgs> {};

#{ stdenv, jdk11_headless, maven, makeWrapper }:
with stdenv;
let dependencies =

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



;
in mkDerivation rec {
  pname = "maven-application";
  version = "1.0.0";
  #inherit version;
  #JA
  name = "${pname}-${version}";
  #src = ./.;

  # should not have to specify twice...
  src = fetchurl {
      url = "https://github.com/nick-less/freerouting/archive/master.tar.gz";
      sha256 = "0b7s78fg70avh2bqqvwpfz2b4vv0ys79nncgg5q2svsf4jczsv03";

    };



  buildInputs = [ jdk maven makeWrapper ];
  buildPhase = ''
    # 'maven.repo.local' must be writable so copy it out of nix store
    mvn package --offline -Dmaven.repo.local=${dependencies}/.m2
  '';

  installPhase = ''
    # create the bin directory
    mkdir -p $out/bin

    # create a symbolic link for the lib directory
    ln -s ${dependencies}/.m2 $out/lib

    # copy out the JAR
    # Maven already setup the classpath to use m2 repository layout
    # with the prefix of lib/
    #cp target/${name}.jar $out/

    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    #makeWrapper ${jdk}/bin/java $out/bin/${pname} \
    #      --add-flags "-jar $out/${name}.jar"

    ls -la

    x=freerouting-1.0.2-SNAPSHOT-jar-with-dependencies.jar

    cp target/$x  $out/bin

    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
          --add-flags "-jar $out/bin/$x"
  '';
}


