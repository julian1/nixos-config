# build.nix
/*

  see freerouting-dependencies.nix first,
*/


with import <nixpkgs> {};

with stdenv;
let dependencies =

  callPackage ({ stdenv,  fetchurl,  maven,  jdk,  javaPackages }: stdenv.mkDerivation rec {


    pname = "maven-dependencies";
    version = "1.0.0";

    src = fetchurl {
        url = "https://github.com/nick-less/freerouting/archive/master.tar.gz";
        #sha256 = "0b7s78fg70avh2bqqvwpfz2b4vv0ys79nncgg5q2svsf4jczsv03";
        #sha256 = "1yccc633mxc8dwf2ipg7vz67d3fgwh4bisazgalvk0h57zyr8iwb";  # 15 may 2021

        sha256 = "0divpa8pslw047xgakzcbnh3rjkwpn31pixh6scm0v27lx8sp3pw";  # 25 jul 2021

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
    # have to update on each install.
      # outputHash = "125pz9c0rca1hf0a7n5pgj6r1pvmp4sbj659dk61x32kkqmk6x5g";
      #outputHash = "00sv4awj7fklcimrfm7hkqnnix09g3zs583rhsd173cf7p6h6ac8";
      # outputHash = "0ksb4rpxz3xydn0x5z6a8q08gk5p6hqc3zrkqwkjv4rrhnk0vc5r";
      # outputHash = "0zz53grdv3qalj7fir0ylbaafh8pxc2njy3j1i7irzdlp2y37w2h";   # 15 may 2021
      #outputHash = "13gmf97yqc3cjxg9bjy6llzfwxg3x5mv2lx3qbmidhrhg33p0sdf";   # 21 may 2021
      outputHash = "11r4hmd5c3kxxfd8dyikfx6hz0qvrnl5ig3pdc5c6mb63s3hfs05";



}) {};

in


mkDerivation rec {
  pname = "freerouting";
  version = "1.0.0";
  #inherit version;
  #JA
  name = "${pname}-${version}";
  #src = ./.;

  # should not have to specify twice...
  src = fetchurl {
      url = "https://github.com/nick-less/freerouting/archive/master.tar.gz";
      # sha256 = "0b7s78fg70avh2bqqvwpfz2b4vv0ys79nncgg5q2svsf4jczsv03";
      #sha256 = "1yccc633mxc8dwf2ipg7vz67d3fgwh4bisazgalvk0h57zyr8iwb";  # 15 may 2021
      sha256 = "0divpa8pslw047xgakzcbnh3rjkwpn31pixh6scm0v27lx8sp3pw";  # 25 jul 2021
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


