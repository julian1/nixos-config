##!/bin/bash

for i in "bashrc" "vimrc" "screenrc"  "gitconfig" ; do 
  echo $i; 
  ln -sf "$(pwd)/$i" "$HOME/.$i"
done


for i in ".vim" ".vim/backup" ".vim/swap"  ".vim/undo" ".vim/autoload" ".vim/bundle"; do 
  echo $i; 
  [ -d "$HOME/$i" ] ||  mkdir "$HOME/$i"
done

# ssh public keys?
# not by default?

