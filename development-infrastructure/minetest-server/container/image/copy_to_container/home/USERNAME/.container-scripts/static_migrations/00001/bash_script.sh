#!/bin/bash

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/header.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/symlinks/symlinks.sh"

############################################################################################
# CORE SCRIPTS
############################################################################################

function create_core_script_link() {
  create_symlink "$HOME/$1" "$CONTAINER_SCRIPTS/core_scripts/$1.sh"
}

create_core_script_link "build"
create_core_script_link "clean"
create_core_script_link "sync"
create_core_script_link "deploy"
create_core_script_link "run"
