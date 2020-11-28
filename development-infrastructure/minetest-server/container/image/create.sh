#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/header.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/user/user.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/symlinks/symlinks.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/git/git.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/copy/copy.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/ssh/ssh.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/service/service.sh"

USERNAME=$(user_username)

function install_lib() {
  local SOURCE=$1
  local LIBRARY=$2
  local DESTINATION="$SCRIPT_DIR/copy_to_container/home/USERNAME/.container-scripts/$LIBRARY"
  copy_directory_not_symlink "$SOURCE" "$DESTINATION"
  git_ignore "$SCRIPT_DIR/copy_to_container/home/USERNAME/.container-scripts" "$LIBRARY"
}
install_lib "$SCRIPT_DIR/lib" "lib"

function create_core_script_link() {
  symlink_create_migration "\$HOME/$1" "\$HOME/.container-scripts/core_scripts/$1.sh"
}

rm -rf "$SCRIPT_DIR/copy_to_container/home/USERNAME/.container-scripts/migrations/*"
migrations_init "$SCRIPT_DIR/copy_to_container/home/USERNAME/.container-scripts/migrations"

  ssh_create_migration_install_authorized_key "$USERNAME" "minetest_server"
  create_core_script_link "build"
  create_core_script_link "clean"
  create_core_script_link "sync"
  create_core_script_link "deploy"
  create_core_script_link "run"
  service_start_create_migration "rsyslog"
  service_start_create_migration "ssh"

migrations_teardown

PASSWORD="password"

docker build \
  --build-arg USERNAME="$USERNAME" \
  --build-arg UID="$UID" \
  --build-arg PASSWORD="$PASSWORD" \
  --tag minetest-development-with-osx-and-docker-image \
  --file "$SCRIPT_DIR/Dockerfile" \
  "$SCRIPT_DIR"
