#! /bin/sh

function link_files () {
  from=$1
  destination=$2

  mkdir -p $destination
  for f in $from
  do
    echo "Linking $f to $destination"
    ln -sf $f $destination
  done
}

# remember to double quote the first one with expansions
link_files "$(pwd)/neovim/*" ~/.config/nvim/
