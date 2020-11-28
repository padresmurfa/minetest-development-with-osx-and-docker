[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/service" && exit 1

# start:
#   starts a service
# usage:
#   service_start "<service name>"
function service_start() {
  local SERVICE_NAME="$1"
  sudo service "$SERVICE_NAME" start >> /dev/null
}
