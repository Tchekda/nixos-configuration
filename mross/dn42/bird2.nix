{ pkgs, lib, ... }:
let
  script = pkgs.writeShellScriptBin "update-roa" ''
    mkdir -p /etc/bird/
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
    ${pkgs.bird2}/bin/birdc c 
    ${pkgs.bird2}/bin/birdc reload in all
  '';
  bgp = import peers/bgp.nix { };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{

  systemd.timers.dn42-roa = {
    description = "Trigger a ROA table update";

    timerConfig = {
      OnBootSec = "5m";
      OnUnitInactiveSec = "1h";
      Unit = "dn42-roa.service";
    };

    wantedBy = [ "timers.target" ];
    before = [ "bird.service" ];
  };

  systemd.services = {
    dn42-roa = {
      after = [ "network.target" ];
      description = "DN42 ROA Updated";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${script}/bin/update-roa";
      };
    };
  };



  services = {
    bird-lg = {
      package = pkgs.bird-lg;
      proxy = {
        allowedIPs = [ "172.20.4.97" "172.20.4.98" "fd54:fe4b:9ed1:1::1" "fd54:fe4b:9ed1:2::1" ];
        birdSocket = "/var/run/bird/bird.ctl";
        enable = true;
        listenAddress = "[fd54:fe4b:9ed1:1::1]:8000";
      };
      frontend = {
        enable = true;
        servers = [ "fr-par" "fr-lyn" ];
        domain = "node.tchekda.dn42";
        listenAddress = "127.0.0.1:5050";
      };
    };

    bird2 = {
      enable = true;
      checkConfig = false; # Can't import ROA before-hand
      config = builtins.readFile ./bird.conf + lib.concatStrings (builtins.map
        (x: "
      protocol bgp ${x.name} from dnpeers {
        neighbor ${x.neigh} as ${x.as};
        ${if x.multi || x.v4 then "
        ipv4 {
                extended next hop on;
                import where dn42_import_filter(${x.link},25,34);
                export where dn42_export_filter(${x.link},25,34);
                import keep filtered;
        };
        " else ""}
        ${if x.multi || x.v6 then "
        ipv6 {
                extended next hop on;
                import where dn42_import_filter(${x.link},25,34);
                export where dn42_export_filter(${x.link},25,34);
                import keep filtered;
        };
        " else ""}
    }
        ")
        bgp.sessions) + bgp.extraConfig;
    };
  };

  users.users.tchekda.extraGroups = [ "bird2" ];
}
