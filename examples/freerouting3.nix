
/*
  nix-build  ~/nixos-config/examples/freerouting3.nix

  This fails,
    suspect the reason is that networking is denied during build phase,


  [INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.253 s
[INFO] Finished at: 2020-09-12T06:45:00Z
[INFO] ------------------------------------------------------------------------
[ERROR] Plugin org.apache.maven.plugins:maven-javadoc-plugin:3.2.0 or one of its dependencies could not be resolved: Failed to read artifact descriptor for org.apache.maven.plugins:maven-javadoc-plugin:jar:3.2.0: Could not transfer artifact org.apache.maven.plugins:maven-javadoc-plugin:pom:3.2.0 from/to central (https://repo.maven.apache.org/maven2): repo.maven.apache.org: Name or service not known: Unknown host repo.maven.apache.org: Name or service not known -> [Help 1]
org.apache.maven.plugin.PluginResolutionException: Plugin org.apache.maven.plugins:maven-javadoc-plugin:3.2.0 or one of its dependencies could not be resolved: Failed to read artifact descriptor for org.apache.maven.plugins:maven-javadoc-plugin:jar:3.2.0


*/

with import <nixpkgs> {}; 

# makeWrapper, ant,
callPackage ({ stdenv,  fetchFromGitHub, fetchurl,  maven,  jdk,  javaPackages    }: stdenv.mkDerivation rec {


  pname = "maven-and-java";
  version = "1.0.0";


   src = fetchurl {
      url = "https://github.com/nick-less/freerouting/archive/master.tar.gz";
      sha256 = "0b7s78fg70avh2bqqvwpfz2b4vv0ys79nncgg5q2svsf4jczsv03";

    };
 

  nativeBuildInputs = [ maven ];
  buildInputs = [ jdk ];

  buildPhase = ''
    # use compiled jogl to avoid patchelf'ing .so files inside jars

    echo hi
    pwd
    ls -la
    #ls -la ../

    # ping -c 3 8.8.8.8

    mvn -X clean install

  '';

  installPhase = ''
    mkdir $out
    cp -dpR build/linux/work $out/${pname}
  '';

  meta = with stdenv.lib; {
    description = "A language and IDE for electronic arts";
    homepage = https://processing.org;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}) {} 


