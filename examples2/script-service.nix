{config, pkgs, ... }:

{
  # You can actually remove the user, and still use it
  # as a user if you link it in ~/.config/systemd/user/
  # (do not forget to remove the `user` it in anything.nix
  # as well)
  config.systemd.services.mytestservice = {

  #systemd.user.services.mytestservice = {   # can't manage to see this in journalctl ... 
   description = "Mytestservice";
   script = "while true; do echo 'YES'; echo $(date) ; sleep 300; done";

   # script = "while true; do echo 'YES'; sleep 1; done";

   # Or:
   # serviceConfig = {
   #   ExecStart = "${pkgs.bash}/bin/bash -c \"while true; do echo 'YES'; sleep 1; done\"";
   # };
   wantedBy = [ "default.target" ];
 };
}
