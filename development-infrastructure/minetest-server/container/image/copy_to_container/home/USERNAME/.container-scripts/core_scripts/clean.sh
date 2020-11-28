#!/bin/bash

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail

############################################################################################
# SYNC FILES TO BUILD
############################################################################################

function clean_files() {
    local DIR=$1
    pushd "$DIR" >> /dev/null
    git clean -dxf
    popd >> /dev/null
}

clean_files "$HOME/source/games/minetest_game"
clean_files "$HOME/source/minetest"

echo "Cleaned all git repositories"
