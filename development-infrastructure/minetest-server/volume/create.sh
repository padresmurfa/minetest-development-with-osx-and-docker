#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/header.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/docker/volume/volume.sh"

VOLUME=$1

EXISTS=$(docker_volume_exists "$VOLUME")
if [[ -n $EXISTS ]]; then
  exit_with_message "The '$VOLUME' volume already exists"
else
  docker_volume_create "$VOLUME"
  echo "Created docker volume '$VOLUME'"
fi
