{ tunnel, ospf, ... }:
let
  defaultPubKey = "MY_PUB_KEY"; # No really used in the config but keeping it to find it easily
  defaultPrivKey = "MY_PRIV_KEY";
in
{
  tunnel_name = tunnel { LOCAL_PORT } defaultPrivKey "{REMOTE_PUB_KEY}" "{REMOTE_HOST:REMOTE_PORT}" "{INTERFACE_NAME}" "{TUNNEL_IPV4}" "{TUNNEL_IPV6}";
  }
