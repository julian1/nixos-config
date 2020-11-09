{ lib,  pkgs, ... }:
with lib;
{

  # Enable the OpenSSH daemon.
  config.services.openssh.enable = true;
  # config.services.openssh.permitRootLogin = "without-password";

  # Nov 2020. AWS conflict.
  config.services.openssh.permitRootLogin = "prohibit-password";

  # Nov 2020 for AWS
  services.openssh.forwardX11 = true

  # JA usePAM is default
  # think would need the %u is user, %h is home /root/.ssh...
  # services.openssh.authorizedKeysFiles = ["%h/.ssh/authorized_keys"];
  # services.openssh.authorizedKeysFiles = ["/root/.ssh/authorized_keys"];
  # services.openssh.authorizedKeysFiles = ["~/.ssh/authorized_keys"];

  # pubkey root
  config.users.extraUsers.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd9DazuhCPLh9YcW8BtHTIWZ+k4ZXo7TtI55f2r/r1MXF/odbQsYb+lJmLMStp8ncHyH7YUaWBvWlz6q9ourkXixYuf255NjrVxBsnqWW58xPwtnRz7jVtVr2oBuId8Uf1o4HCou2a5vLRhuajq6Xd/VHz4z2kpcCsdObiteHqzrLCoZCtDlKxlcGADC057OqZM1FrIV1+2T5ZnN/PDwXphK0D+ZnHm2Sd5n0prpR4NfVtnlq3/68o5xzS2Wm4FhHXF2DqDzolC6OnPWHMqYNXn2vbmQD05Ef4iix0O8cYQ888QQ4/cUnW4ONPPCk1ixv8xqpXsLSAt8EdQjQsZRHB me" ];


  # pubkey me
  config.users.extraGroups.me.gid = 1000;

  config.users.extraUsers.me =
   { isNormalUser = true;
     home = "/home/me";
     description = "my description";
     extraGroups = [ "me" "wheel" "networkmanager" ];
     openssh.authorizedKeys.keys =
        [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd9DazuhCPLh9YcW8BtHTIWZ+k4ZXo7TtI55f2r/r1MXF/odbQsYb+lJmLMStp8ncHyH7YUaWBvWlz6q9ourkXixYuf255NjrVxBsnqWW58xPwtnRz7jVtVr2oBuId8Uf1o4HCou2a5vLRhuajq6Xd/VHz4z2kpcCsdObiteHqzrLCoZCtDlKxlcGADC057OqZM1FrIV1+2T5ZnN/PDwXphK0D+ZnHm2Sd5n0prpR4NfVtnlq3/68o5xzS2Wm4FhHXF2DqDzolC6OnPWHMqYNXn2vbmQD05Ef4iix0O8cYQ888QQ4/cUnW4ONPPCk1ixv8xqpXsLSAt8EdQjQsZRHB me" ];
   };


	# should give sudo to root, without password, for wheel users.
  # config.security.sudo = {
  #   enable = true;
  #   wheelNeedsPassword = false;
  # };

   
 }
