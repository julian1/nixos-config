# change name environment... since this configures default packages
{ lib,  pkgs, ... }:
with lib;

{
  config.users.users.root.packages =
    with pkgs;[ vim git screen less man psmisc ]; # glibcLocales  


  config.users.users.me.packages =

  # system is mostly unusable without a good working vim.
  # note we symlink config files, so not really needed for root.
  # https://www.mpscholten.de/nixos/2016/04/11/setting-up-vim-on-nixos.html
  let

    myVim =
    pkgs.vim_configurable.customize {
        # Specifies the vim binary name.
        name = "vim";
        # CHANGE this - to just read a file from dotfiles
        vimrcConfig.customRC = builtins.readFile ( ../dotfiles/vimrc ) ;
        # dec 2019. Install dotfiles by hand

        vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
          # loaded on launch
          start = [ vim-nix  ];

          # manually loadable by calling `:packadd $plugin-name`
          # opt = [ phpCompletion elm-vim ];
          # To automatically load a plugin when opening a filetype, add vimrc lines like:
          # autocmd FileType php :packadd phpCompletion
        };
    };

    # likewise for git
    # https://qnikst.github.io/posts/2018-08-22-long-live-dotfiles.html
    # https://github.com/qnikst/homster/tree/master/git
    myGit =
      pkgs.git.overrideAttrs (old: {
        configureFlags = [ "--with-gitconfig=$out/etc/gitconfig" ];
        postInstall = ''
          mkdir $out/etc/
          cp "${../dotfiles/gitconfig}" $out/etc/gitconfig
        '';
      });
  in

  # note less, nc, netstat, curl, rsync are installed by default
  with pkgs;

  [ myVim myGit screen less man psmisc ];

  config.environment.etc = {

    # Whoot. fixed screen message. uses /etc/screenrc
    # eg. nix-repl> pkgs.screen.configureFlags
    # [ "--enable-telnet" "--enable-pam" "--with-sys-screenrc=/etc/screenrc" "--enable-colors256" ]
    # screenrc = myScreen;

    screenrc = {
        text = builtins.readFile ( ../dotfiles/screenrc ) ;
        mode = "0444";
      };

    # bashrc/ bash_aliases
    "bashrc.local" = {
      text = builtins.readFile ( ../dotfiles/bashrc ) ;
      mode = "0444";
    };
  };


  config.system.activationScripts =  {

    #  should do root also???
    myfiles =
        ''
        echo "making local vim dirs"
        for i in ".vim" ".vim/backup" ".vim/swap"  ".vim/undo" ".vim/autoload" ".vim/bundle"; do
          # echo $i;
          [ -d "/home/me/$i" ] || mkdir "/home/me/$i" && chown me: "/home/me/$i"
        done
        '';
    };
}

