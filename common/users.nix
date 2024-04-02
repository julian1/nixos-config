{ lib,  pkgs, ... }:

let pubkey =  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd9DazuhCPLh9YcW8BtHTIWZ+k4ZXo7TtI55f2r/r1MXF/odbQsYb+lJmLMStp8ncHyH7YUaWBvWlz6q9ourkXixYuf255NjrVxBsnqWW58xPwtnRz7jVtVr2oBuId8Uf1o4HCou2a5vLRhuajq6Xd/VHz4z2kpcCsdObiteHqzrLCoZCtDlKxlcGADC057OqZM1FrIV1+2T5ZnN/PDwXphK0D+ZnHm2Sd5n0prpR4NfVtnlq3/68o5xzS2Wm4FhHXF2DqDzolC6OnPWHMqYNXn2vbmQD05Ef4iix0O8cYQ888QQ4/cUnW4ONPPCk1ixv8xqpXsLSAt8EdQjQsZRHB me" ;
in

with lib;
{


  # JA usePAM is default
  # think would need the %u is user, %h is home /root/.ssh...
  # services.openssh.authorizedKeysFiles = ["%h/.ssh/authorized_keys"];
  # services.openssh.authorizedKeysFiles = ["/root/.ssh/authorized_keys"];
  # services.openssh.authorizedKeysFiles = ["~/.ssh/authorized_keys"];

  # pubkey root
  config.users.extraUsers.root.openssh.authorizedKeys.keys = [ pubkey ];


  # need to restart Xorg for group changes to take effect, on all spawned shells.
  # may even need a reboot to fix the group...
  # test using ssh localhost.

  # trusted can read /home/me if, chmod 770 /home/me/

  config.users.groups.plugdev = {};


  config.users.extraGroups.me.gid = 1000;
  config.users.extraUsers.me =
   { isNormalUser = true;
     home = "/home/me";
     description = "me user";
    # feb23 2022. add trusted.
     extraGroups = [ "me" "wheel" "networkmanager"  "dialout" "trusted" "large" "plugdev" ];    # is trusted here necessary
     openssh.authorizedKeys.keys = [ pubkey ];


    # Allow trusted to read and write me. But not the other way around. 
    homeMode = "770";
   };



  config.users.extraGroups.trusted.gid = 1001;
  config.users.extraUsers.trusted =
   { isNormalUser = true;
     home = "/home/trusted";
     description = "trusted user";
     extraGroups = [ "trusted" "wheel" "networkmanager" "plugdev" ];     # feb22 2022.remove me
     openssh.authorizedKeys.keys = [ pubkey ];
   };


  #What is the difference between users and extraUsers?

  config.users.extraGroups.large.gid = 1002;
  config.users.extraUsers.large =
   { isNormalUser = true;
     home = "/home/large";
     description = "large user";

    # https://github.com/NixOS/nixpkgs/pull/168168
    # This is enough to give me access to read and write - using the large group.
    homeMode = "770";
   };





	# should give sudo to root, without password, for wheel users.
  # config.security.sudo = {
  #   enable = true;
  #   wheelNeedsPassword = false;
  # };


 }
