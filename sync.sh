#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/header.sh"

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/synchronizer/synchronizer.sh"

synchronizer_init "$ROOT_DIRECTORY/source" "$ROOT_DIRECTORY/.destination/source"
  synchronizer_exclude_git_ignored_files_from_subfolder "minetest"
  synchronizer_exclude_git_ignored_files_from_subfolder "games/minetest_game"
  synchronizer_synchronize
synchronizer_teardown

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/migrations/migrations.sh"

synchronizer_init "$ROOT_DIRECTORY/.destination/source/" "$ROOT_DIRECTORY/.destination/minetest-server/source"
  migrations_init "$ROOT_DIRECTORY/.destination/minetest-server/migrations"
  synchronizer_create_migration
  migrations_apply
  migrations_teardown
synchronizer_teardown

synchronizer_init "$ROOT_DIRECTORY/.destination/source/" "$ROOT_DIRECTORY/.destination/minetest-mac-build-machine/source"
  migrations_init "$ROOT_DIRECTORY/.destination/minetest-mac-build-machine/migrations"
  synchronizer_create_migration
  migrations_apply
  migrations_teardown
synchronizer_teardown

