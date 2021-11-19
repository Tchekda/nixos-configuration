{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nginx.nix
    ];

  # Use the GRUB 2 boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        version = 2;
        splashImage = null;
        device = "/dev/sda"; # or "nodev" for efi only
      };
    };
  };

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "kbennett"; # Define your hostname.

    defaultGateway = { address = "10.0.10.1"; interface = "ens18"; };

    dhcpcd = {
      enable = true;
      extraConfig = ''
        noipv6
      '';
    };

    firewall.enable = false;

    interfaces.ens18 = {
      ipv4 = {
        #       addresses = [{ address = "10.0.10.67"; prefixLength = 24; }];
      };
      ipv6 = {
        addresses = [{ address = "2a01:cb05:8fdb:2555:e490:e2ff:fe7b:497e"; prefixLength = 64; }];
      };
      #      useDHCP = true;
      tempAddress = "disabled";
    };

    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tchekda = {
    description = "David Tchekachev";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAzZARI4tFaQ1T2g5Ug63IXpoLlKYTqnBoja/wam/+QsVH2I4/9t/LBS675+xWJ55UdTpxhkcHYplcvdR4PB3gR5rK/Eqqv7lZEpyriarfdiBuOS0XBYJANpDsGuzeAU7SPL2Kxn8FyWMxqQZeCHyO5fTXhOAUhay5C7n0ym7Ep1Lck3l9eT+sNOPNa5F+bnWheeQG4HkueBiSqt1nUCZA1NQnyvBAFP439/oNVkBXe5q/63eSuDdbq45h5HgR8512HZO857oceLql6PFWIhaG0eF0ifgwqcbNN7iNJ3wFUigb/nR0WZgJwLdUxzUIWyLZz/7Lwn+RatKIL/uicfb/ tchekda@Tchekda" # ASUS computer
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    nano
    git
    htop
    lnav
  ];
  # List services that you want to enable:
  virtualisation.docker.enable = true;
  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  system.stateVersion = "21.05"; # Did you read the comment?

}
