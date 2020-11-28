[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/migrations/dispatcher" && exit 1

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/migrations/register_all_migrations_here.sh"

# apply:
#   applies all unapplied migrations
# usage:
#   migrations_apply
function migrations_apply() {
  while [[ 1 -eq 1 ]]; do
    local UNAPPLIED_MIGRATION_DIR=$(migrations_get_next_unapplied_migration)
    if [[ -z "$UNAPPLIED_MIGRATION_DIR" ]]; then
      break
    fi
    local MIGRATION_TYPE=$(migrations_get_migration_type "$UNAPPLIED_MIGRATION_DIR")
    eval "$MIGRATION_TYPE" "$UNAPPLIED_MIGRATION_DIR"
    migrations_applied_migration "$UNAPPLIED_MIGRATION_DIR"
  done
}
