#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/header.sh"

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/symlinks/symlinks.sh"

function create_lib_symlink() {
  create_symlink "$ROOT_DIRECTORY/development-infrastructure/$1/lib" "$ROOT_DIRECTORY/lib"
}
function create_source_symlink() {
  create_symlink "$ROOT_DIRECTORY/development-infrastructure/$1/source" "$ROOT_DIRECTORY/source"
}

create_lib_symlink "minetest-server/container/image"
create_lib_symlink "minetest-server/container"
create_lib_symlink "minetest-server/volume"
create_source_symlink "minetest-server/container"
