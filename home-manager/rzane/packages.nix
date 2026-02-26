{ pkgs, ... }:
{
  home.packages = with pkgs; [
    actionlint
    awscli2
    colima
    docker
    docker-compose
    docker-buildx
    docker-credential-helpers
    fzf
    gh
    git
    k9s
    kubectl
    mkcert
    mise
    nss
    pre-commit
    terraform-ls
    vault
  ];
}
