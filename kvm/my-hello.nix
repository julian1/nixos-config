
# cannot return an array here...

with import <nixpkgs> {}; # bring all of Nixpkgs into scope

let my-hello =  
  stdenv.mkDerivation rec {
    name = "hello-2.8";
    src = fetchurl {
      url = "mirror://gnu/hello/${name}.tar.gz";
      sha256 = "0wqd8sjmxfskrflaxywc7gqw7sfawrfvdxd9skxawzfgyy0pzdz6";
    };
}; 

in  [ my-hello screen vim git wget ]



