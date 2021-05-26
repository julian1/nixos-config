
/*
  https://blog.trailofbits.com/2019/01/17/how-to-write-a-rootkit-without-really-trying/

  searchable index,
    https://filippo.io/linux-syscall-table/

  cat /proc/kallsyms | grep sys_call_table

  CONFIG_KALLSYMS y
  CONFIG_KALLSYMS_ALL y
  CONFIG_KALLSYMS_EXTRA_PASS y
*/

{ lib,  pkgs, ... }:

with lib;
{
   boot.kernelParams = [  ];

   boot.kernelPatches = [ {
         name = "kallsyms-config";
         patch = null;
         extraConfig =  ''
              KALLSYMS y
              KALLSYMS_ALL y
              # KALLSYMS_EXTRA_PASS y
      ''
               ;
         } ];

}

