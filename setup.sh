#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/header.sh"

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/symlinks/symlinks.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/git/git.sh"

function create_lib_symlink() {
  local RELATIVE_PATH="development-infrastructure/$1/lib"
  create_symlink "$ROOT_DIRECTORY/$RELATIVE_PATH" "$ROOT_DIRECTORY/lib"
  git_ignore "$SCRIPT_DIR" "$RELATIVE_PATH"
}

function create_source_symlink() {
  local RELATIVE_PATH="development-infrastructure/$1/source"
  create_symlink "$ROOT_DIRECTORY/$RELATIVE_PATH" "$ROOT_DIRECTORY/source"
  git_ignore "$SCRIPT_DIR" "$RELATIVE_PATH"
}

create_lib_symlink "minetest-server/container/image"
create_lib_symlink "minetest-server/container"
create_lib_symlink "minetest-server/volume"
create_source_symlink "minetest-server/container"
