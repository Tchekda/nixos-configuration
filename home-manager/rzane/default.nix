{
  lib,
  unstable,
  pkgs,
  ...
}:

{
  imports = [
    ../home.nix
    ./git.nix
    ./packages.nix
    # Secure-Enclave agent SSH wiring. Kept in a git-crypt'd module so the
    # public repo never carries the agent name, socket path or key filename.
    ./secrets/agent.nix
  ];

  # The fish-ssh-agent plugin is redundant on hosts whose SSH auth is delegated
  # to an agent socket (see ./secrets/agent.nix). Other hosts keep it.
  tchekda.fishSshAgent.enable = false;

  home = {
    sessionVariables = {
      TF_CLI_ARGS_plan = "-parallelism=50";
      TF_CLI_ARGS_apply = "-parallelism=50";
    };
  };

  programs = {
    command-not-found.enable = lib.mkForce false;
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    fish = {
      shellAbbrs = {
        nrs = "sudo darwin-rebuild --flake /Users/dtch/nixos-configuration#rzane switch";
        cc = "claude --dangerously-skip-permissions --effort max";
      };
      shellInit = ''
        mise activate fish --shims | source
        source "${pkgs.asdf-vm}/share/fish/vendor_completions.d/asdf.fish"
      '';
    };

    # mise is installed via Homebrew (see ../../rzane/homebrew.nix). Fish activation
    # happens in `programs.fish.shellInit` above via `mise activate fish --shims | source`.
    # Removed `programs.mise` block to avoid shadowing brew's mise on PATH.

    ssh = {
      enable = true;
      includes = [
        "/Users/dtch/.colima/ssh_config"
        "/Users/dtch/.ssh/local_config"
      ];
    };
  };
}
