
/*
  Use this first, as a build pre-step to download maven dependencies.
  Can then use freerouting-build in a sandboxed environment without network access

  USE.
  > nix-build ~/devel/nixos-config/examples/freerouting-dependencies.nix  -I nixpkgs=/home/me/devel/nixpkgs/

  > nix-build ~/devel/nixos-config/examples/freerouting-dependencies.nix  -I nixpkgs=/home/me/devel/nixpkgs/ 2>&1  | tee freerouting.log

  See. relies on FOD. to allow making networking calls.
  https://fzakaria.com/2020/07/20/packaging-a-maven-application-with-nix.html
  -----------

  If nothing happens, and it doesn't start download. then change the outputHash to force it to download.

  then run 
  nix-build examples/freerouting-build.nix

  then run,
  ./result/bin/freerouting

  OK. THIS WORKED!!.   downloading an old version.
  nix-build ~/devel/nixos-config/examples/freerouting-dependencies.nix   2>&1  | tee freerouting.log

  BUT THIS DOESN'T
  nix-build ~/devel/nixos-config/examples/freerouting-dependencies.nix  -I nixpkgs=/home/me/devel/nixpkgs/ 2>&1  | tee freerouting.log

*/

with import <nixpkgs> {};

callPackage ({ stdenv,  fetchurl,  maven,  jdk,  javaPackages }: stdenv.mkDerivation rec {


  pname = "maven-dependencies";
  version = "1.0.0";

#  src = fetchurl {
#      url = "https://github.com/nick-less/freerouting/archive/master.tar.gz";
#      # sha256 = "0b7s78fg70avh2bqqvwpfz2b4vv0ys79nncgg5q2svsf4jczsv03";
#      # sha256 = "1yccc633mxc8dwf2ipg7vz67d3fgwh4bisazgalvk0h57zyr8iwb";  # 15 may 2021
#      sha256 = "0divpa8pslw047xgakzcbnh3rjkwpn31pixh6scm0v27lx8sp3pw";  # 25 jul 2021
#
#    };

  src = (fetchFromGitHub {
      owner = "nick-less";
      repo = "freerouting";
      # rev = "master";
      #rev = "ff48e2e670c3"; // master 25 jul 2021
      # rev = "41ad87fd5e5";
      # rev = "13e3c27148d0a2a37f3ad0058af6753a2caa61a7";
      rev = "c85175f8a58570a331ba67155437a33791b20823a";  # Mar 18, 2020

 

      sha256 = "0pl986ljv8qc3hmfswjb9l6pkpil15lnizhjkw31a4l1h0kz0phl";
      fetchSubmodules = true; # needed to use fetchgit internally
    #  leaveDotGit = true; # needed to preserve the .git dir
    #  postFetch = ''
    #    git lfs init
    #    git lfs fetch
    #    # anything else needed to check out lfs files
    #    # possibly delete .git now
    #  '';
    });

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
    #outputHash = "125pz9c0rca1hf0a7n5pgj6r1pvmp4sbj659dk61x32kkqmk6x5g";
    # outputHash = "1icph2pvl5m437cprsk2mrjiwblk6q4cqlzrcx465lcj2spam139";   # 15 may 2021
    # outputHash = "0bkf5f4vz4m6px2s6n9ylym8c226bszxdlsr7x2jq8fskq9kn82g";   # 21 may 2021
    outputHash =   "0vqgyr490np4wi05ngc7ry93p34qb0488z19c6dyy86am2ga7frk";   


}) {}


