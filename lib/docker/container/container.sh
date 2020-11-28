[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/docker/container" && exit 1

# list:
#   Lists docker containers
# usage:
#   docker_container_list > "$OUTPUT_TO_FILE"
function docker_container_list() {
  docker ps
}

# container_id_from_name:
#   Determines the container id of the specified name container
# usage:
#   ID=$(docker_container_id_from_name "container name")
function docker_container_id_from_name() {
  local CONTAINER_NAME=$1
  docker ps --quiet --filter name="$CONTAINER_NAME" | awk '{ print $1 }'
}

# container_ipaddress_from_name:
#   Determines the ipaddress of the specified named container
# usage:
#   IPADDRESSS=$(docker_container_ipaddress_from_name "container name")
function docker_container_ipaddress_from_name() {
  local CONTAINER_NAME=$1
  # shellcheck disable=SC2155
  local CONTAINER_ID=$( docker_container_id_from_name "$CONTAINER_NAME" )
  docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_ID"
}

# container_is_running_by_name:
#   Determines whether or not the specified named container is running
# usage:
#   ISRUNNING=$(docker_container_is_running_by_name "container name")
function docker_container_is_running_by_name() {
  local CONTAINER_NAME=$1
  docker ps --quiet --filter name="$CONTAINER_NAME"
}

# container_execute_bash_as_user:
#   Executes a bash command in a container as a user
# usage:
#   docker_container_execute_bash_as_user "container name" "user name" "bash command" > "$OUTPUT_TO_FILE"
function docker_container_execute_bash_as_user() {
  local CONTAINER_NAME=$1
  local USERNAME=$2
  local COMMAND=$3
  docker exec --tty --user "$USERNAME" --workdir "/home/$USERNAME" "$CONTAINER_NAME" /bin/bash -c "$COMMAND"
}

# container_stop:
#   Stops a docker container
# usage:
#   docker_container_stop "container name"
function docker_container_stop() {
  local CONTAINER_NAME=$1
  docker stop "$CONTAINER_NAME" >> /dev/null
}

# container_bash_shell:
#   Opens a bash shell in a container
# usage:
#   docker_container_bash_shell "container name"
function docker_container_bash_shell() {
  local CONTAINER_NAME=$1
  docker exec --interactive --tty "$CONTAINER_NAME" /bin/bash
}
