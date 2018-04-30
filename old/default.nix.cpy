
# OK. This works to give us a custom vimRC !!!!
# and works to set the shell
# so we need git configuration
# and we have ssh keys...   maybe can place in here...

# https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/vim-utils.nix
# using a local directory 

# nixpkgs = $NIX_PATH
# with import <nixpkgs> {};
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let myVim = 
  vim_configurable.customize {
      # Specifies the vim binary name.
      name = "vim";
      # CHANGE this - to just read a file from dotfiles
      # vimrcConfig.customRC = builtins.readFile ( ''/home/me/dotfiles/vimrc'' ) ;
      vimrcConfig.customRC = builtins.readFile ( "${./dotfiles/vimrc}" ) ;

      vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [ vim-nix  ];

        # manually loadable by calling `:packadd $plugin-name`
        # opt = [ phpCompletion elm-vim ];
        # To automatically load a plugin when opening a filetype, add vimrc lines like:
        # autocmd FileType php :packadd phpCompletion
      };
  };

# unused...
in 

# nix-repl> pkgs.bashInteractive.configureFlags
# nix-repl> pkgs.bashInteractive.overrideAttrs
# # should this be  bash_interactive  or  bashInteractive ??? or are they the same
# pbashInteractive.overrideAttrs (
# bashInteractive.postInstall
# # OK. this seemed to get it to try and compile...
# # need to somehow set it as the one to use...
# /nix/store/rm1hz1lybxangc8sdl7xvzs5dcvigvf7-bash-4.4-p23/bin/bash
let myBash = 
	bashInteractive.overrideAttrs (old: { 

		configureFlags = [ "--rcfile=$out/etc/bashrc" ];
		postInstall = ''
		    mkdir $out/etc/
		    cp "${./dotfiles/bashrc}" $out/etc/bashrc
		  '';

		} );

#	'' alias test="ls -la" '';

# https://qnikst.github.io/posts/2018-08-22-long-live-dotfiles.html
# https://github.com/qnikst/homster/tree/master/git
in 
let myGit = 
  git.overrideAttrs (old: {
	  configureFlags = [ "--with-gitconfig=$out/etc/gitconfig" ];
	  postInstall = ''
	    mkdir $out/etc/
	    cp "${./dotfiles/gitconfig}" $out/etc/gitconfig
	  '';
	});

#(old: {
#    # gettext UTF-8 failures?
#    doInstallCheck = false;
#    });

in

# OK  issue is that bash_aliases are lots when 
# we start screen...
# vimrc is ok.
# gitconfig is ok.
# its just the shellHook that's problematic 


stdenv.mkDerivation {
  name = "my-example";

  # the src can also be a local folder, like:
  #src = ~/dotfiles;
  #shellHook = ''
  #  alias test="ls -la"
  #'';

  # OK - hang on this may not be necessary....
  # bashrc should read bash_aliases
  # shellHook =  myBash;
  # OK. But just linking bash_aliases works nicely
  # shellHook = builtins.readFile ( ''/home/me/dotfiles/bash_aliases'' ) ;
  #  TODO change name. bashrc
  shellHook = builtins.readFile ( "${./dotfiles/bashrc}" ) ;

  # config.environment.shellAliases
  # shellAliases = ''   ''
 
  # doesn't seem to do anything
  # interactiveShellInit = ''whoot=ls'';

  # OK, seems like this is in scope... but cannot change it...	
  # options.programs.bash.interactiveShellInit.value = [ "whoot=ls" ] ;
  # options.programs.bash.interactiveShellInit = { value = "whoot=ls" } ;

  #options.programs.bash = { 
#	#-- old;
#	interactiveShellInit.value = ''whoot=ls'' ;
#  }

   
  buildInputs = [
    # vim_configurable
    # pkgs.vim
    myVim
    man
    myGit
    myBash
  ];

}
