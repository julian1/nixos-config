
# vim and git
# bash and screen moved into configuration.nix...

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
in




#	'' alias test="ls -la" '';

# https://qnikst.github.io/posts/2018-08-22-long-live-dotfiles.html
# https://github.com/qnikst/homster/tree/master/git
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


# example of wrapped


let
  wrapped = pkgs.writeScriptBin "hello" ''
    !${pkgs.stdenv.shell}
    exec ${pkgs.hello}/bin/hello -t
    '';
in
let j =  pkgs.symlinkJoin {
    name = "hello";
    paths = [
      wrapped
      pkgs.hello
    ];
  };
in
	

let k = pkgs.symlinkJoin {
  name = "bash";
  buildInputs = [makeWrapper];
  paths = [ bash ];
  postBuild =
    ''
    wrapProgram "$out/bin/bash" --add-flags "--rcfile ./dotfiles/bashrc"
    '';
};
in





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
  #shellHook = builtins.readFile ( "${./dotfiles/bashrc}" ) ;

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
    # myBash
    j
    k
    # m
  ];

}
