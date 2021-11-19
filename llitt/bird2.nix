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

  systemd.services.dn42-roa = {
    after = [ "network.target" ];
    description = "DN42 ROA Updated";
    unitConfig = {
      Type = "one-shot";
    };
    serviceConfig = {
      ExecStart = "${script}/bin/update-roa";
    };
  };
  services.bird2 = {
    enable = true;
    checkConfig = false;
    config = builtins.readFile ./bird.conf + lib.concatStrings (builtins.map
      (x: "
      protocol bgp ${x.name} from dnpeers {
        neighbor ${x.neigh} as ${x.as};
        ${if x.multi || x.v4 then "
        ipv4 {
                import where dn42_import_filter(${x.link},25,34);
                export where dn42_export_filter(${x.link},25,34);
                import keep filtered;
        };
        " else ""}
        ${if x.multi || x.v6 then "
        ipv6 {
                import where dn42_import_filter(${x.link},25,34);
                export where dn42_export_filter(${x.link},25,34);
                import keep filtered;
        };
        " else ""}
    }
        ")
      bgp.sessions) + bgp.extraConfig;
  };
}
