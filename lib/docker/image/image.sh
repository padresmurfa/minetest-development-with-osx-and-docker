[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/docker/image" && exit 1

# erase:
#   Erases a docker image
# usage:
#   docker_image_erase "image tag"
function docker_image_erase() {
  local IMAGE_TAG=$1
  docker image rm --force "$IMAGE_TAG"
}
