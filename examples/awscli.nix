
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

# awscli. which is a pain to insteall with pip, python.
# works great. just needs credentials
# [nix-shell:~/nixos-config]$ ls ~/.aws/
# config  credentials


pkgs.stdenv.mkDerivation {
  name = "my-example";

  shellHook = ''figlet "Welcome!" | lolcat --freq 0.5'';

  buildInputs = [
    figlet
    lolcat
    awscli
  ];
}
