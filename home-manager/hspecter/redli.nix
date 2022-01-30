{ buildGoModule, fetchFromGitHub, lib }:
buildGoModule rec {
  name = "redli";
  version = "v0.5.2";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = name;
    rev = version;
    sha256 = "sha256-bR02R9M3041oNUEQId1zgAxMNPyXXQNAYEyE/XIDdPE=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Redli - A humane alternative to the Redis-cli and TLS ";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = licenses.asl20;
    maintainers = with maintainers; [ tchekda ];
    platforms = platforms.all;
  };
}
