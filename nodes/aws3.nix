{ modulesPath, ... }: {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" 

	/root/nixos-config/common/users.nix
	/root/nixos-config/common/dotfiles.nix
];
  ec2.hvm = true;


  networking.hostName = "aws3"; # Define your hostname.

  
}
