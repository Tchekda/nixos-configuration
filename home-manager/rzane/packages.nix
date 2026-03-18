{ pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    actionlint
    awscli2
    colima
    docker
    docker-compose
    docker-buildx
    docker-credential-helpers
    unstable.fastlane
    fzf
    gh
    git
    k9s
    kubectl
    mkcert
    nss
    pre-commit
    shellcheck
    terraform-ls
    vault
  ];
}
