#!/bin/bash

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail


############################################################################################
# BUILD Terasology
############################################################################################

if [[ ! -d "$HOME/source/minetest" ]]; then
  >&2 echo "The minetest server repository was not found at '$HOME/source/minetest'. Please sync before building."
  exit 1
fi

pushd "$HOME/source/minetest" >> /dev/null

NUMBER_OF_PROCESSORS=$(nproc)
cmake . -DRUN_IN_PLACE=TRUE -DBUILD_SERVER=TRUE -DBUILD_CLIENT=FALSE
make -j"$NUMBER_OF_PROCESSORS"

popd >> /dev/null
