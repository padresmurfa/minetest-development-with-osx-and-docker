[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/bash" && exit 1

# apply_migration:
#   applies a migration
# usage:
#   bash_apply_migration <migration_dir>
function bash_apply_migration() {
  local MIGRATION_DIR="$1"
  /bin/bash -c "$MIGRATION_DIR/bash_script.sh"
}
