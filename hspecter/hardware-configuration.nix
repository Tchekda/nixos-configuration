{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.root = { # Luks setup from https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134
        device = "/dev/disk/by-uuid/e0286394-29de-4117-8ee4-af6b643eeeff"; # blkid /dev/nvme0n1p2 (crypted part)
        preLVM = true;
        allowDiscards = true;
      };
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  }; 

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1a74202a-7048-4be1-b5aa-565cb1f2b05b"; # Id the the part root part
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ]; # better for SSD
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3429-189C"; # id of the boot FAT32 EFI partition
      fsType = "vfat";
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/392fb1b7-c2a1-48a8-a221-d60e5ce6a2d2"; } ];
}
