{ pkgs, config, ... }:
{
  users.users.tchekda.extraGroups = [ "docker" ];
  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--ipv6 --fixed-cidr-v6 2001:bc8:2e2a:1::/64";
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
  };
}
