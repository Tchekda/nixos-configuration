#! /usr/bin/env bash

echo "use nix" > .envrc

echo "{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
  ];
}

" > shell.nix

@direnv_bin@ allow