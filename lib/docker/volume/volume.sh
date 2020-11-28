[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/docker/volume" && exit 1

# exists:
#   Determines whether or not a named docker volume exists
# usage:
#   EXISTS=$(docker_volume_exists <volume_name>)
#   interpret empty as false, a string as true
function docker_volume_exists() {
  local VOLUME_NAME=$1
  # if the docker volume exists, a string will be returned, otherwise empty will be returned
  docker volume ls --quiet --filter "name=$VOLUME_NAME"
}

# create:
#   Creates a docker volume, with the provided name
# usage:
#   docker_volume_create <name>
function docker_volume_create() {
  local VOLUME_NAME=$1
  docker volume create $VOLUME_NAME >> /dev/null
}

# delete:
#   Deletes the docker volume with the provided name
# usage:
#   docker_volume_delete <name>
function docker_volume_delete() {
  local VOLUME_NAME=$1
  docker volume rm $VOLUME_NAME >> /dev/null
}

# list:
#   Lists docker volumes
# usage:
#   docker_volume_list > "$OUTPUT_TO_FILE"
function docker_volume_list() {
  docker volume ls
}
