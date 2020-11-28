#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/header.sh"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/docker/container/container.sh"

CONTAINER_NAME="minetest"

IS_RUNNING=$(docker_container_is_running_by_name "$CONTAINER_NAME")
if [[ -z $IS_RUNNING ]]; then
  exit_with_message "The '$CONTAINER_NAME' container is not running"
else
  docker_container_bash_shell "$CONTAINER_NAME"
fi
