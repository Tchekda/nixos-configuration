{ stdenv, buildGoModule, fetchFromGitHub, fetchhg, fetchbzr, fetchsvn, lib, mod }:

buildGoModule rec {
  name = "bird-lg-go";
  version = "1.0";

  vendorSha256 = "sha256-7LZeCY4xSxREsQ+Dc2XSpu2ZI8CLE0mz0yoThP7/OO4=";

  modRoot = mod;

  ldflags = [
    "-s"
    "-w"
  ];

  doDist = false;

  src = fetchFromGitHub {
    owner = "xddxdd";
    repo = "bird-lg-go";
    rev = "af5b653326936ede439380d1a88b5ed96e4e7e8c";
    sha256 = "sha256-NURyhXYZjBxzrxGNc2RmWu9s/K5WFXSyRZoiEYhqnqs=";
  };
}
