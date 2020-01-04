/*{ parityListenAddress }:*/ { lib,  pkgs,  ... }:

with lib;

let
    nixpkgs = import <nixpkgs> {};

    version     = "2.5.13";
    sha256      = "0imfdjcg42jfnm897mgjyg0lj4dffsv44z74v0ilwqwqp9g9hwvx";
    cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";

    # we should be able to call this directly
    myParity = import ./parity.nix { inherit version sha256 cargoSha256; }
      (with nixpkgs; { inherit lib fetchFromGitHub rustPlatform cmake openssl pkgconfig systemd ; })
      ;

in
{
  # we can pass the ipAddress explicitly, since  from define the

  config.users.users.me.packages = [ myParity ] ;

  config.systemd.services.parity = {
				wantedBy = [ "multi-user.target" ];
				after = [ "network.target" ];
				description = "Start parity session";
				serviceConfig = {
					Type = "simple";
					# IMPORTANT - user must be valid!!!
					User = "me";
					ExecStart = ''
            ${myParity}/bin/parity \
              -d /home/me/data \
              --jsonrpc-cors "all" \
              --jsonrpc-hosts "all" \
              --jsonrpc-interface 127.0.0.1 \
              --ws-interface 127.0.0.1 \
              --interface 206.189.42.212 \
              --allow-ips=public \
              --no-ancient-blocks \

            '';
          KillSignal="SIGHUP";
				};
		 };
}




#ExecStart = ''${myParity}/bin/parity -d /home/me/data'';
# ExecStop = "pkill parity";
# ExecStop = "";


    #myScript = pkgs.writeScriptBin "myScript" ''
#
#      ${myParity}/bin/parity -d /home/me/data
#
#      '';




# systemctl status parity
# journalctl -uf parity.service
# systemctl stop parity

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

