{ config, ... }:
{
  imports = [
    ../git.nix
  ];
  # Define overrides
  programs.git = {
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1GCcwzSkhPhlOZz+iYO59ehl+HfwYftQVGHs82Qs61";
      format = "ssh";
      signByDefault = true;
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
    settings = {
      # Always use SSH cloning instead of HTTPS (to avoid entering credentials)
      url."ssh://git@github.com".insteadOf = "https://github.com";

      # Enable colored output in Git commands
      color.ui = "auto";

      # Enable reuse recorded resolution for merge conflicts
      rerere.enabled = true;

      # Prune remote-tracking branches that no longer exist on the remote
      fetch.prune = true;

      # Set the default branch name for new repositories
      init.defaultBranch = "master";

      # Update references when rebasing (useful for stacked pull requests)
      rebase.updateRefs = true;

      # Specify the global excludes file and editor
      core = {
        excludesfile = "~/.gitignore_global";
      };

      user.email = [ ]; # Overriden by the global gitconfig

      # delete-squashed: delete local branches that were squashed into main
      alias.delete-squashed = ''!f() { local mainBranch=$(git symbolic-ref refs/remotes/origin/HEAD | cut -d/ -f4) && git checkout -q $mainBranch && git pull && git branch --merged | grep -v "\*" | xargs -n 1 git branch -d && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base $mainBranch $branch) && [[ $(git cherry $mainBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done; }; f'';

      # allowedSignersFile has no dedicated option; program is set via signing.signer
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/empty-allowedSignersFile";
    };
  };
}
