{config, pkgs, ... }:

{
  # https://unix.stackexchange.com/questions/523454/nixos-use-services-on-non-nixos-os-eventually-with-only-user-rights

  config.systemd.services.mytestservice = {

   description = "Mytestservice";
   script = "while true; do echo YES $( whoami &&  date) ; sleep 300; done";

   serviceConfig = {
      User = "me";
   };
   wantedBy = [ "default.target" ];
 };
}


# can't manage to see this in journalctl ... . should be user.me.services ?
#systemd.user.services.mytestservice = {

# script = "while true; do echo 'YES'; sleep 1; done";

# Or:
# serviceConfig = {
#   ExecStart = "${pkgs.bash}/bin/bash -c \"while true; do echo 'YES'; sleep 1; done\"";
# };

