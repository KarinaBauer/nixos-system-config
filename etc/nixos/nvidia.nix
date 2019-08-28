{ config, pkgs, ... }:

{
  hardware.bumblebee.enable = true;
  # disable card with bbswitch by default since we turn it on only on demand!
  # hardware.nvidiaOptimus.disable = true;
  # install nvidia drivers in addition to intel one
  # hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
  # hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 ];
  # hardware.opengl.driSupport32Bit = true;
}
