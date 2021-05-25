/*
  note. not for nano isntance.
  tested on 4GB to build stuff, and 20GN storage.
  else oom.

*/
{ modulesPath, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" 

	/root/nixos-config/common/users.nix
	/root/nixos-config/common/dotfiles.nix
];
  ec2.hvm = true;


  networking.hostName = "aws3"; # Define your hostname.

  
}
