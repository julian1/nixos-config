{ lib,  pkgs, ... }:
with lib;
{


  config.users.extraUsers.me =
    { 
     openssh.authorizedKeys.keys =
        [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4FdwhYu403nrePZ3GyDH439To9/EoVWniQyLE1173fTRkpE/vtHLPlgWmojvLtHVOlAwdOs0ZI2UtsIMHbeYc+EHKo014Dw+wLpZitjInrTsiqTFwtkrtMm4QLNAxQSnPF51QloNLHN1AfUNO7Ni9pDleumSO1SIjX8Sa10sNral8fzrUGBfulf6cOlTA3MBV3Nb3TUxhgvqRJ9YyiL6ymBDKFe44TtsBXtQQ3SkHkHNCp3yBi/43H38qfxKvRA+NEQ4uFfXFVNf8Us7LpmaMATcO4AR2ZrpPQ11v+YfeZRN+Mb7byEhRJgMjf2Ib0wGADSRY/YaCaEfrFvJoZtOZ my comment" ];
   };

 }

