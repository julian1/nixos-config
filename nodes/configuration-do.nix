# /etc/nixos/configuration should look something like this
# change name of this to dexter... also can we bind some arguments... yes.

{ modulesPath, lib, ... }:
{


  # _module.args.xhostname = "ahostname";

  # config.services.parity. parityListenAddress  = "206.189.42.212";
  config.services.parity. parityListenAddress  = "all";
 
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ] 
        ++ [ 
            /home/me/nixos-config/common/basic20.nix   # note v20
            /home/me/nixos-config/common/keys.nix  
            /home/me/nixos-config/common/dotfiles.nix 
                
            /home/me/nixos-config/examples2/myparity/service.nix  # { parityListenAddress = "206.189.42.212"; }  won't work. because paths. not calls.
        ] 
  ;


  config.networking.hostName = "dexter";


  # parityListenAddress = "206.189.42.212"; 


}


