{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" =
      {
        device = "/dev/disk/by-uuid/1695c257-7b07-46f3-a296-ddc847aed4e3";
        fsType = "ext4";
      };
    "/srv" =
      {
        device = "/dev/disk/by-uuid/8b966d2f-6ce7-47de-8087-33ce3318d94e";
        fsType = "ext4";
      };
  };

  swapDevices = [ ];

}
