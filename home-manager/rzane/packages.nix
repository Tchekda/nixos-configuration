{ pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    actionlint
    # awscli2 # system level for Lens app
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
    mailcatcher
    mkcert
    nss
    pre-commit
    ripgrep
    shellcheck
    terraform-ls
    uv
    vault
  ];
}
