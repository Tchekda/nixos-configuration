{ pkgs, config, ... }:
{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        52822
        5443
        45230
      ];
      trustedInterfaces = [ "lxdbr0" ];
      # Port forwarding port 52822 to 10.199.33.34:22
      extraCommands = ''
        iptables -t nat -A PREROUTING -p tcp --dport 52822 -j DNAT --to-destination 10.199.33.34:22
        iptables -t nat -A PREROUTING -p tcp --dport 5443 -j DNAT --to-destination 10.199.33.34:5443
        iptables -t nat -A PREROUTING -p udp --dport 45230 -j DNAT --to-destination 10.199.33.34:45230
        iptables -t nat -A POSTROUTING -s 10.199.33.34/32 -o lxdbr0 -j MASQUERADE
      '';
    };
  };
  users.users.tchekda.extraGroups = [ "lxd" ];
  virtualisation = {
    lxd = {
      enable = true;
      recommendedSysctlSettings = true;
    };
  };
}
