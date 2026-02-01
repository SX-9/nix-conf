{ pkgs, hostname, username, git, rice, ctp-opt, flake-path, mc, ... }: {
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
    packages = with pkgs; [
      vscode # lets see how long you survive as my default code editor
      zed-editor

      discord
      slack
      brave

      appimage-run
      #winboat
      libreoffice
      #keepassxc
      vlc
      remmina
      moonlight-qt
      kdePackages.kdenlive
      inkscape
      #davinci-resolve

      (wrapOBS {
        plugins = with obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      })

      portablemc
      ferium
      virt-manager

      zsh-completions
      zsh-syntax-highlighting
      kitty
      bat
      btop
      ranger

      gh
      go
      bun
      #nodejs # pkgs.buildEnv error: two given paths contain a conflicting subpath
      nodePackages.npm
      nodePackages.pnpm
      nodePackages.yarn
      python314
      jdk25_headless
    ];
  };

  xdg = {
    autostart.enable = true;
    mimeApps = {
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
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  programs = {
    tmux.enable = true;
    vim.enable = true;
    bat.enable = true;
    zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
      extensions = [ "nix" ];
      userSettings = {
        features.edit_prediction_provider = "copilot";
        vim_mode = true;
        git.inline_blame.enabled = true;
        gutter.line_numbers = true;
        relative_line_numbers = "enabled";
        minimap.show = "never";
        autosave.after_delay.milliseconds = 1000;
        tab_size = 2;
        ui_font_size = 16;
        buffer_font_size = 15;
        base_keymap = "VSCode";
        file_types.tailwindcss = [ "*.css" ];
        auto_install_extensions.catppuccin-icons = true;
        icon_theme = "Catppuccin Mocha";
        theme = {
          mode = "dark";
          light = "Catppuccin Mocha (sapphire)";
          dark = "Catppuccin Mocha (sapphire)";
        };
        lsp.discord_presence.initialization_options = {
          application_id = "1263505205522337886";
          base_icons_url = "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/";
          state = "Working on {filename}";
          details = "In {workspace}";
          large_image = "{base_icons_url}/{language:lo}.png";
          large_text = "{language:u}";
          small_image = "{base_icons_url}/zed.png";
          small_text = "Zed";
          git_integration = true;
          idle = {
            timeout = 300;
            action = "change_activity";
            state = "Idling";
            details = "In Zed";
            large_image = "{base_icons_url}/zed.png";
            large_text = "Zed";
            small_image = "{base_icons_url}/idle.png";
            small_text = "Idle";
          };
        };
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        font_family = rice.font;
        background_opacity = 0.8;
        background_blur = 4;
        window_padding_width = 8;
        cursor_shape = "beam";
        cursor_trail = 10;
        copy_on_select = true;
      };
    };
    ranger = {
      enable = true;
      aliases = {
        "sh" = "shell zsh";
        "zed" = "shell zeditor .";
        "vim" = "shell vim";
        "img" = "shell eog .";
      };
    };
    btop = {
      enable = true;
      settings = {
        update_ms = 100;
        shown_boxes = "proc cpu";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      initLua = ''
        vim.opt.clipboard = "unnamedplus"
        vim.opt.termguicolors = true
        require("nvim-tree").setup()
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            -- vim.cmd("NvimTreeOpen")
            vim.cmd.wincmd 'p'
          end,
        })
      '';
      plugins = with pkgs.vimPlugins; [
        bufferline-nvim
        nvim-web-devicons
        nvim-treesitter
        nvim-lspconfig
        telescope-file-browser-nvim
        nvim-tree-lua
        nvim-cmp
        barbar-nvim
        indent-blankline-nvim
        markdown-preview-nvim
      ];
    };
    gh = {
      enable = true;
      settings.editor = "nvim";
      gitCredentialHelper.enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-skyline
        gh-eco
      ];
    };
    git = {
      enable = true;
      settings = {
        pull.rebase = "true";
        user = {
          name = git.user;
          email = git.email;
        };
      };
    };
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
        "cd-gvfs" = "cd /run/user/$(id -u)/gvfs";
        "wlp-set" = "swww img --transition-type=grow --transition-duration=1";
        "ssh" = "TERM=xterm-256color ssh";

        "sys" = "sudo systemctl";
        "sys-log" = "journalctl -f -b -u";
        "user" = "systemctl --user";
        "user-log" = "journalctl -f -b --user-unit";

        "ts" = "sudo tailscale";
        "tsip" = "tailscale ip -4";
        "rmall" = "rm -rf ./* ./.*"; # scary!
        "srmall" = "sudo rm -rf ./* ./.*"; # also scary!

        "fetch-update" ="rm -f ~/.fetch.sh && wget https://raw.githubusercontent.com/SX-9/fetch.sh/master/fetch.sh -O ~/.fetch.sh && chmod +x ~/.fetch.sh";
        "fetch" = "~/.fetch.sh";

        "hm-sw" = "home-manager switch -b bak-hm --flake";
        "nix-sw" = "sudo nixos-rebuild switch --flake";
        "nix-hw-conf" = "nixos-generate-config --show-hardware-config";
        "cd-conf" = "cd ${flake-path}";
        "code-conf" = "zeditor ${flake-path}";

        "mkdistro" = "distrobox create -Y -i";
        "mkdistro-arch" = "mkdistro archlinux -n arch";
        "mkdistro-deb" = "mkdistro debian -n deb";
        "win11-compose" = "docker compose --file ~/.config/winapps/compose.yaml";
        "wm-ctl" = "hyprctl --instance 0";
        "wm-lock" = "wm-ctl dispatch exec loginctl lock-session && notify-send ${hostname} 'Manual lock triggered'";
        "wm-dpms" = "wm-ctl dispatch dpms";

        "git-author-setup" = "git config user.name $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user | jq -r .login) && git config user.email $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user/emails | jq -r \".[1].email\")";
        "mcl" = "portablemc start ${mc.version} -l ${mc.email}";
        "mc" = "ferium upgrade; mcl";

        "please" = "SUDO_PROMPT=\"What is the magic word? \" sudo";
        "pls" = "SUDO_PROMPT=\"What is the magic word? \" sudo";
      };
      initContent = ''
        if [[ -z "$SSH_CONNECTION" && $(tput cols) -ge 64 && $(tput lines) -ge 16 ]]; then
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
