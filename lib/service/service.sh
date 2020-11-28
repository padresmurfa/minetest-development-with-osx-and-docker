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

# start_create_migration:
#   creates a migration that starts a service
# usage:
#   service_start_create_migration "<service name>"
function service_start_create_migration() {
  local SERVICE_NAME="$1"
  migrations_create_next_migration "service_start_apply_migration" "$SERVICE_NAME"
}

# start_apply_migration:
#   applies a migration
# usage:
#   service_start_apply_migration <migration_dir>
function service_start_apply_migration() {
  local MIGRATION_DIR="$1"
  local SERVICE_NAME=$(migrations_get_migration_context "$MIGRATION_DIR")
  service_start "$SERVICE_NAME"
}
