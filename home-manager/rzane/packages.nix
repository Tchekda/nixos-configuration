{ pkgs, unstable, ... }:
{
  # Tools also managed by Homebrew (see ../../rzane/homebrew.nix) are not listed here
  # so brew's copies in /opt/homebrew/bin/ are the active ones on PATH. This lets
  # tools that the BSP dev-env-setup script expects (docker, gh, kubectl, vault, etc.)
  # be picked up by `brew upgrade` and version checks.
  home.packages = with pkgs; [
    actionlint
    asdf-vm
    bun
    # awscli2 # system level for Lens app
    unstable.fastlane
    git
    k9s
    mailcatcher
    mariadb
    mkcert
    nss
    pre-commit
    ripgrep
    shellcheck
    terraform-ls
    uv
    # vault stays in nix: brew formula `hashicorp/tap/vault` has no macOS
    # bottle and the source build requires xcode-select pointing at the
    # standard CLT, conflicting with this machine's nix-darwin SDK pin.
    vault
  ];
}
