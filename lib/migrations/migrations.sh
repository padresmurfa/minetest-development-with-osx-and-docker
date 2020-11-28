[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/migrations" && exit 1

# must not start with a 0 (which would imply base-b), and must be large enough to ensure that we
# never run out of migration ids
LOWEST_LEGAL_MIGRATION_ID="1000000000"

# init:
#   initializes the migrations library
# usage:
#   migrations_init "<migrations folder>"
function migrations_init() {
  if [[ ! -d "$1" ]]; then
    mkdir -p "$1"
  fi
  MIGRATIONS_DIRECTORY="$(abspath "$1")"
}

# teardown
#   tears down the migration tool, releasing system resources if needed.
# usage:
#   migrations_teardown
function migrations_teardown() {
  # nothing to do at the moment
  echo "ignore" >> /dev/null
}

# get_next_unapplied_migration:
#   Gets the directory next un-applied migration, or an empty string if there are no un-applied migrations
# usage:
#   DIR=$(migrations_get_next_unapplied_migration)
function migrations_get_next_unapplied_migration() {
  local FILENAME="$MIGRATIONS_DIRECTORY/.next_migration_id"
  local NEXT_MIGRATION_ID
  if [[ -f "$FILENAME" ]]; then
    NEXT_MIGRATION_ID=$(cat "$FILENAME")
  else
    NEXT_MIGRATION_ID="$LOWEST_LEGAL_MIGRATION_ID"
  fi
  FILENAME="$MIGRATIONS_DIRECTORY/.oldest_unapplied_migration_id"
  local UNAPPLIED_MIGRATION_ID
  if [[ -f "$FILENAME" ]]; then
    UNAPPLIED_MIGRATION_ID=$(cat "$FILENAME")
  else
    UNAPPLIED_MIGRATION_ID="$LOWEST_LEGAL_MIGRATION_ID"
  fi
  if [[ "$NEXT_MIGRATION_ID" == "$UNAPPLIED_MIGRATION_ID" ]]; then
    echo ""
  else
    echo "$MIGRATIONS_DIRECTORY/$UNAPPLIED_MIGRATION_ID"
  fi
}

# applied_migration:
#   Handles book-keeping after a migration is applied
# usage:
#   migrations_applied_migration "$MIGRATION_DIR"
function migrations_applied_migration() {
  local ACTUALLY_APPLIED_MIGRATION_DIR="$1"
  local FILENAME="$MIGRATIONS_DIRECTORY/.oldest_unapplied_migration_id"
  local EXPECTED_MIGRATION_ID
  if [[ -f "$FILENAME" ]]; then
    EXPECTED_MIGRATION_ID=$(cat "$FILENAME")
  else
    EXPECTED_MIGRATION_ID="$LOWEST_LEGAL_MIGRATION_ID"
  fi
  local EXPECTED_MIGRATION_DIR="$MIGRATIONS_DIRECTORY/$EXPECTED_MIGRATION_ID"
  if [[ "$EXPECTED_MIGRATION_DIR" != "$ACTUALLY_APPLIED_MIGRATION_DIR" ]]; then
    abort "expected migration dir != actual migration dir"
  fi
  local NEW_UNAPPLIED_MIGRATION_ID=$((EXPECTED_MIGRATION_ID+1))
  echo "$NEW_UNAPPLIED_MIGRATION_ID" > "$FILENAME"
}

# reserve_next_migration_id:
#   Reserves the next migration id
# usage:
#   ID=$(migrations_reserve_next_migration_id)
function migrations_reserve_next_migration_id() {
  local FILENAME="$MIGRATIONS_DIRECTORY/.next_migration_id"
  local NEXT_MIGRATION_ID="$LOWEST_LEGAL_MIGRATION_ID"
  if [[ -f "$FILENAME" ]]; then
    NEXT_MIGRATION_ID=$(cat "$FILENAME")
  fi
  echo "$NEXT_MIGRATION_ID"
  local NEW_MIGRATION_ID=$((NEXT_MIGRATION_ID+1))
  echo "$NEW_MIGRATION_ID" > "$FILENAME"
}

# create_next_migration:
#   creates a migration of a specific type, with a specific context, returning the directory name of the migration
# usage:
#   DIR=$(migrations_create_next_migration <type> <context>)
function migrations_create_next_migration() {
  local MIGRATION_TYPE
  MIGRATION_TYPE="$1"
  local MIGRATION_CONTEXT
  MIGRATION_CONTEXT="$2"
  local MIGRATION_ID
  MIGRATION_ID="$(migrations_reserve_next_migration_id)"
  local MIGRATION_DIR="$MIGRATIONS_DIRECTORY/$MIGRATION_ID"
  mkdir "$MIGRATION_DIR" >> /dev/null
  echo "$MIGRATION_TYPE" > "$MIGRATION_DIR/type"
  if [[ -n "$MIGRATION_CONTEXT" ]]; then
    echo "$MIGRATION_CONTEXT" > "$MIGRATION_DIR/context"
  fi
  echo "$MIGRATION_DIR"
}

# get_migration_context:
#   retrieves the generic migration context
# usage:
#   CONTEXT=$(migrations_get_migration_context "migration_dir")
function migrations_get_migration_context() {
  local MIGRATION_DIR="$1"
  if [[ -f "$MIGRATION_DIR/context" ]]; then
    cat "$MIGRATION_DIR/context"
  else
    echo ""
  fi
}

# get_migration_type:
#   retrieves the migration type
# usage:
#   TYPE=$(migrations_get_migration_type "migration_dir")
function migrations_get_migration_type() {
  local MIGRATION_DIR="$1"
  cat "$MIGRATION_DIR/type"
}
