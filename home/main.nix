{ pkgs, username, git, rice, ctp-opt, flake-path, mc, ... }: {
  catppuccin = {
    flavor = ctp-opt.flavor;
    accent = ctp-opt.accent;
    enable = true;
  };
  imports = if rice.enable then [
    ../rice/home.nix
  ] else [];
  
  home = {
    stateVersion = "24.11";
    username = "${username}";
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "brave";
      TERMINAL = "kitty";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "nvim.desktop";
      "text/html" = "brave-browser.desktop";
      "application/pdf" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/terminal" = "kitty.desktop";
      "x-terminal-emulator" = "kitty.desktop";
      "inode/directory" = "pcmanfm-qt.desktop";
      "audio/mpeg" = "vlc.desktop";
      "audio/mp3" = "vlc.desktop";
      "audio/wav" = "vlc.desktop";
      "audio/flac" = "vlc.desktop";
      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";
    };
  };

  programs = {
    gh = {
      enable = true;
      settings.editor = "nvim";
      gitCredentialHelper.enable = true;
      extensions = with pkgs; [
        gh-dash gh-skyline gh-eco
      ];
    };
    git = {
      enable = true;
      userName = git.user;
      userEmail = git.email;
      extraConfig.pull.rebase = "true";
    };
    tmux.enable = true;
    pay-respects = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--alias"
        "f"
      ];
    };
    zsh = {
      enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        NIXPKGS_ALLOW_UNFREE=1
        WINEPREFIX="~/.wine"
        WINEARCH="win64"
        DISPLAY=":0"
        EDITOR="nvim"
        PORT="3000"
      '';
      shellAliases = {
        "sys" = "sudo systemctl";
        "sys-log" = "journalctl -f -b -u";
        "user" = "systemctl --user";
        "user-log" = "journalctl -f -b --user-unit";
        
        "ts" = "sudo tailscale";
        "tsip" = "tailscale ip -4";
        "rmall" = "rm -rf ./* ./.*"; # scary!
        "srmall" = "sudo rm -rf ./* ./.*"; # also scary!

        "fetch-update" = "rm -f ~/.fetch.sh && wget https://raw.githubusercontent.com/SX-9/fetch.sh/master/fetch.sh -O ~/.fetch.sh && chmod +x ~/.fetch.sh";
        "fetch" = "~/.fetch.sh";

        "hm-sw" = "home-manager switch -b bak-hm --flake";
        "nix-sw" = "sudo nixos-rebuild switch --flake";
        "nix-hw-conf" = "nixos-generate-config --show-hardware-config";
        "cd-conf" = "cd ${flake-path}";
        "code-conf" = "code ${flake-path}";

        "mkdistro" = "distrobox create -Y -i";
        "mkdistro-arch" = "mkdistro archlinux -n arch";
        "mkdistro-deb" = "mkdistro debian -n deb";
        "win11-compose" = "docker compose --file ~/.config/winapps/compose.yaml";
        "wm-ctl" = "hyprctl --instance 0";

        "git-author-setup" = "git config --global user.name $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user | jq -r .login) && git config --global user.email $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user/emails | jq -r \".[1].email\")";
        "mcl" = "portablemc start ${mc.version} -l ${mc.email}";
        "mc" = "ferium upgrade; mcl";
      };
      initContent = ''
        if [[ $TERM_PROGRAM != 'vscode' && -z "$SSH_CONNECTION" && $(tput cols) -ge 64 && $(tput lines) -ge 16 ]]; then
          # ~/.fetch.sh -c 2> /dev/null
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
