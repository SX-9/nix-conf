{ username, git, ... }: {
  catppuccin = {
    flavor = "mocha";
    enable = true;
  };
  home = {
    stateVersion = "24.11";
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
  programs = {
    git = {
      enable = true;
      userName = git.user;
      userEmail = git.email;
      extraConfig.pull.rebase = "true";
    };
    tmux.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        WINEPREFIX="~/.wine"
        WINEARCH="win64"
        DISPLAY=":0"
        EDITOR="vim"
        PORT="3000"
      '';
      shellAliases = {
        "zshrc" = "echo 'WARNING: please use home-manager config instead, press enter to continue' && read && vim ~/.zshrc && omz reload";
        "sys" = "sudo systemctl";
        "user" = "systemctl --user";
        "sys-log" = "journalctl --follow -b -u";
        "user-log" = "journalctl --follow -b --user-unit";
        "tsip" = "tailscale ip -4";
        "rmall" = "rm -rf ./* ./.*";
        "fetch-update" = "rm -f ~/.fetch.sh && wget https://raw.githubusercontent.com/SX-9/fetch.sh/master/fetch.sh -O ~/.fetch.sh && chmod +x ~/.fetch.sh";
        "hm-sw" = "home-manager switch --flake";
        "nix-sw" = "sudo nixos-rebuild switch --flake";
        "mcl" = "portablemc start fabric:1.21 -u";
        "git-author-setup" = "git config --global user.name $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user | jq -r .login) && git config --global user.email $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user/emails | jq -r \".[1].email\")";
      };
      initExtra = ''
        if [[ $TERM_PROGRAM != 'vscode' ]]; then
          echo && ~/.fetch.sh color 2> /dev/null
        fi
      '';
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "refined";
      };
    };
  };
}
