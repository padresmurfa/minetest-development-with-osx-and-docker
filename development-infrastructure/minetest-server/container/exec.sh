#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/header.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/docker/container/container.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/user/user.sh"

COMMAND=$1
CONTAINER_NAME="minetest"

IS_RUNNING=$(docker_container_is_running_by_name "$CONTAINER_NAME")
if [[ -n $IS_RUNNING ]]; then
  USERNAME=$(user_username)
  docker_container_execute_bash_as_user "$CONTAINER_NAME" "$USERNAME" "$COMMAND"
else
  exit_with_message "The '$CONTAINER_NAME' container was not running"
fi
