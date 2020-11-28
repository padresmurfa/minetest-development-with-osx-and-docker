#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/header.sh"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/docker/container/container.sh"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/user/user.sh"

CONTAINER_NAME="minetest"

IS_RUNNING=$(docker_container_is_running_by_name "$CONTAINER_NAME")
if [[ -n $IS_RUNNING ]]; then
  exit_with_message "The '$CONTAINER_NAME' container was already running"
else
  SOURCE_DIRECTORY="$SCRIPT_DIR/source"
  USERNAME=$(user_username)

  echo "Starting the '$CONTAINER_NAME' docker container"
  # run our docker container
  # ... detached from this shell
  # ... removing it automatically when it is stopped
  # ... using a fixed name, minetest, for the running container
  # ... granting read-only access to the shared_with_container folder
  # ... exposing the minetest server on port 11001
  # ... and selecting our docker image, which is named minetest-development-with-osx-and-docker-image
  docker run \
    --detach --tty \
    --rm \
    --name "$CONTAINER_NAME" \
    --publish 127.0.0.1:11001:11001/tcp \
    --publish 127.0.0.1:11001:11001/udp \
    --mount "type=bind,source=$SOURCE_DIRECTORY,destination=/home/$USERNAME/.shared_from_host,readonly" \
    --mount "type=volume,source=minetest-source,destination=/home/$USERNAME/source" \
    --mount "type=volume,source=minetest-servers,destination=/home/$USERNAME/servers" \
    minetest-development-with-osx-and-docker-image >> /dev/null
  echo "... started '$CONTAINER_NAME' successfully"
  echo "... bind-mounted $SOURCE_DIRECTORY into the container as /home/$USERNAME/.shared_from_host"
  echo "... mounted the docker volume 'minetest-source' into the container as /home/$USERNAME/source"
  echo "... mounted the docker volume 'minetest-servers' into the container as /home/$USERNAME/servers"
  CONTAINER_ID=$(docker_container_id_from_name "$CONTAINER_NAME")
  echo "... container ID: $CONTAINER_ID"
  CONTAINER_IPADDRESS=$(docker_container_ipaddress_from_name "$CONTAINER_NAME")
  echo "... container IPAddress: $CONTAINER_IPADDRESS"
fi
