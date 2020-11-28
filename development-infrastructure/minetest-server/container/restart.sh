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
  exit_with_message "The '$CONTAINER_NAME' container was not running"
else
  echo "Restarting the '$CONTAINER_NAME' container"
  echo "... stopping"
  docker_container_stop "$CONTAINER_NAME"
  echo "... stopped"
  echo "... starting"
  "$SCRIPT_DIR/start.sh"
  echo "... started"
  echo "... '$CONTAINER_NAME' was restarted successfully"
fi

