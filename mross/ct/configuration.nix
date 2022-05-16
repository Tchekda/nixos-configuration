{ config, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
      <home-manager-master/nixos>
      ../../tchekda_user.nix
      (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
      ./nginx.nix
      ./wireguard.nix
      ./dn42
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    isContainer = true;
  };

  documentation.enable = false;

  environment.systemPackages = with pkgs; [
    dnsutils
    git
    htop
    iotop
    lnav
    nano
    tcpdump
    wget
  ];

  home-manager.users.tchekda = {
    imports = [ ../../home-manager/mross/default.nix ];
  };


  networking = {
    hostName = "mross-ct";

    firewall.enable = false;
    useDHCP = false;
    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      ipv4 = {
        addresses = [{ address = "192.168.1.102"; prefixLength = 24; }];
      };
      ipv6 = {
        addresses = [{ address = "2001:bc8:2e2a:102::1"; prefixLength = 64; }];
      };
      # tempAddress = "disabled";
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "2001:bc8:2e2a:1::1";
      interface = "eth0";
    };
    nameservers = [ "62.210.16.6" "2606:4700:4700::1111" "1.1.1.1" ];

  };

  nixpkgs.config.allowUnfree = true;

  services = {
    openssh.enable = true;
    vscode-server.enable = true;
  };

  system.stateVersion = "21.11";

  systemd.suppressedSystemUnits = [
    "console-getty.service"
    "getty@.service"
    "systemd-udev-trigger.service"
    "systemd-udevd.service"
    "sys-fs-fuse-connections.mount"
    "sys-kernel-debug.mount"
    "dev-mqueue.mount"
  ];

  time.timeZone = "Europe/Paris";

  users.users = {
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAavYBAIwKDDixRTBJbSHMpkCeN6OMfAMoypSVdYAgpY3OILAUj/HoIJp1uIiKlxJ+v4gLDPjaPWmPPiOW2O4EEiCTEV22DlhcFQZs7DY1Pf7WQnUW1g4PI35LUEWlBOghnB+D11ltU5odTBPVgu1HxNX6pbE1r2MLvox8xt+PHkqXvaPDX7QGPBuAAusK8trEUROObc6+umHPH1VeTK7H810kSGDy1JVPQgK28byh/yJcoHL53XGZ+nCYiuZVFfPmLofPP+LGzulGT2TwNcUiAA8Wv7skSNUdjzXJ4KRZlqIsYiey1vx0hq3+whfC3vLwMBvz90v0HTW+xtEnX4vqR4SeFfRaLpUXpY8rceICgo3XnBQyn/2NNpmbRIJWowK0ENA58psbxo4Z+2qa0is3XLvVc2yqcdd2dLRr+gk3qwEIRcY1m+oGw2u4kv4RkTvboVPTdQozUcTB5EfLKRPB3DnVwULIYbt3QJ5CnW+v+PqinHc2vmAeUaKOEwfufdE= tchekda@hspecter"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvcAT1NgEqQQ2Fy0vaR8aexofFc57Vb9yl+DbmP89VJzqWrixO4mEIEQLyViMV7axUcP10fIage7UJNbRZYcpwsTIbdWkDFflLLHoKuIHlZNyt41khvHdrSlwwO0nw6jCO3gICAXnSPEJCmQx5aLkBNXgjKPMaLwBc7KyLUn00oxVYT4obin7qlqslac+BC6Zg6V9xBwkCb844aeT1jAAvShdTJcDBysphuebdRVNNboSqADpVhFeJeK/mf5VIAodbCFWjQ0KXM3bswc7lavRCfTfe9/R917KF3ettJ9/slLDIdxP97g0WhNPzytDvmqqCCQxKJOmDeHjxguw9rBxA8Z05HuyrEDFCgXSmyEToD7ZN9ip5V4wXTjCVjsJD4f1ds+EG27+1H8cwl7o+lU15/4Cq6jGzzlAUeOK3IVZs+nSqeHNe8HTH7dUZCLG2WWQWlM+G/uuTkSIlN0GOZV3UKTS0yzS/8Vp0rRnMwIGEVw9Rkc64AnzFROyde+5rDMEP3tfpCeUAuFr8K8sGwhU+n7J8NmZsVL3+tmydaB9rivT+Hjvhv3Ru6EGKDDqMANKRNz1QQI18UJczOv51T7AZqIY9VBk4OQYeghRH4CRB7Ls6pa19//9MKPZoxBS/MlSNp5D5YTnBDK5/gtuMo/nnIk7SV+Nz+nIa6IGLxHqoIw== root@pve"
      ];
    };
  };
}
