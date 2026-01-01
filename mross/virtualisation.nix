{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    incus
    btrfs-progs
  ];
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        52822
        5443
      ];
      allowedUDPPorts = [
        45230
      ];
      trustedInterfaces = [
        "lxdbr0"
        "incusbr0"
      ];
    };
    # Might need to run `sudo ip route add 10.8.1.0/24 via 172.29.172.3 dev amn0` on incus CT
    # Script /root/awg-route.sh
    nftables = {
      enable = true;
      ruleset = ''
        table inet portforward {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            
            # Port forwarding to LXD container
            tcp dport 52822 dnat ip to 10.199.33.34:22 # SSH
            tcp dport 5443 dnat ip to 10.199.33.34:5443 # XRAY
            udp dport 45230 dnat ip to 10.199.33.34:45230 # AmneziaWG
          }
          
          chain forward {
            type filter hook forward priority filter; policy accept;
            
            # Allow established/related connections
            ct state established,related accept
            
            # Allow forwarding to/from container
            ip daddr 10.199.33.34 accept
            ip saddr 10.199.33.34 accept
          }
          
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            
            # MASQUERADE for container traffic going out
            ip saddr 10.199.33.34 oifname "incusbr0" masquerade
            ip saddr 10.199.33.34 oifname "lxdbr0" masquerade
          }
        }
      '';
    };
  };
  users.users.tchekda.extraGroups = [
    "incus-admin"
  ];
  virtualisation = {
    incus.enable = true;
  };
}
