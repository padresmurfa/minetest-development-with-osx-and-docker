#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/header.sh"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/user/user.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/symlinks/symlinks.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/git/git.sh"

USER=$(user_username)

function install() {
  local SOURCE=$1
  local DESTINATION="$SCRIPT_DIR/copy_to_container/home/USERNAME/.container-scripts/$2"
  if [[ -d "$DESTINATION" ]]; then
    rm -rf "$DESTINATION"
  fi
  cp -R "$SOURCE" "$DESTINATION"
  git_ignore "$SCRIPT_DIR/copy_to_container/home/USERNAME/.container-scripts" "$2"
}
install "$SCRIPT_DIR/lib" "lib"

docker build \
  --build-arg USERNAME="$USER" \
  --build-arg UID="$UID" \
  --tag minetest-development-with-osx-and-docker-image \
  --file "$SCRIPT_DIR/Dockerfile" \
  "$SCRIPT_DIR"
