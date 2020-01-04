{ lib,  pkgs, ... }:

with lib;

let  
    version     = "2.5.13";
    sha256      = "0imfdjcg42jfnm897mgjyg0lj4dffsv44z74v0ilwqwqp9g9hwvx";
    cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";  

    nixpkgs = import <nixpkgs> {};
 
    # we should be able to call this directly 
    pkgs.parity = import ./parity.nix { inherit version sha256 cargoSha256; }
      (with nixpkgs; { inherit lib fetchFromGitHub rustPlatform cmake openssl pkgconfig systemd ; })
      ;

  in

{

  config.users.users.me.packages = [ pkgs.parity  ] ;

  config.systemd.services.parity = {						# system service
				wantedBy = [ "multi-user.target" ];
				after = [ "network.target" ];
				description = "Start parity session";
				serviceConfig = {
					Type = "simple";
					# IMPORTANT - must ve valid!!!
					User = "me";
					ExecStart = ''${pkgs.parity}/bin/parity -d /home/me/data'';
					# ExecStop = "pkill parity";
					# ExecStop = "";
          KillSignal="SIGHUP";
				};
		 };
}



# procps for pkill
#nixpkgs.procps 

#Type=simple
#ExecStart=/usr/bin/parity
#Restart=on-failure
## SIGHUP gives parity time to exit cleanly before SIGKILL
#KillSignal=SIGHUP



  
  # why is rustPlatform in nixpkgs for nix-build and nix-env but not in pkgs for nixos-rebuild? i want to install my rust binary as service, in configuration.nix but there's no platform support to compile it.

  # with a service compiled by rust

  # environment.systemPackages = [binutils gcc gnumake openssl pkgconfig]
  # config.environment.systemPackages = [ rustPlatform rustc cargo ];


# in  [ pkgs.parity ] ;
/*
	y = rec {

		pkgs = nixpkgs ;

		# config.systemd.user.services.parity = {				# user level service. not sure if path is right.

	};

in
  [ x y ] 
*/

