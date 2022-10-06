# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2dcbee59-dacc-446f-9410-b24b25c48bdc";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AE98-8A44";
      fsType = "vfat";
    };

  fileSystems."/mnt/disk" = {
    device = "/dev/disk/by-uuid/64A98A3A30AD54FE";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" ];
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2b539e77-cdb8-420d-b17a-30a467d5ea2f"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
