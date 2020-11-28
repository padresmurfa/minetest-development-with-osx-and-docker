[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/symlinks" && exit 1

# create_symlink:
#   Creates a symlink from LINK to TARGET
# usage:
#   create_symlink "LINK" "TARGET"
function create_symlink() {
    local LINK="$1"
    local TARGET="$2"

    local LINK_DIRECTORY
    LINK_DIRECTORY=$(dirname "$LINK")
    local LINK_BASENAME
    LINK_BASENAME=$(basename "$LINK")

    pushd "$LINK_DIRECTORY" >> /dev/null || exit 2>&1

      if [[ -L "$LINK_BASENAME" ]]; then
        unlink "$LINK_BASENAME" >> /dev/null 2>&1
      fi
      ln -s "$TARGET" "$LINK_BASENAME"

    popd >> /dev/null || exit 2>&1
}

# create_migration:
#   creates a migration that creates a new symlink
# usage:
#   symlink_create_migration
function symlink_create_migration() {
    local LINK="$1"
    local TARGET="$2"
    # shellcheck disable=SC2155
    local MIGRATION_DIR=$(migrations_create_next_migration "symlink_apply_migration" "")
    echo "$LINK" > "$MIGRATION_DIR/link"
    echo "$TARGET" > "$MIGRATION_DIR/target"
}


# apply_migration:
#   applies a migration
# usage:
#   symlink_apply_migration <migration_dir>
function symlink_apply_migration() {
  local MIGRATION_DIR="$1"

  local LINK=$(cat "$MIGRATION_DIR/link")
  LINK=$(eval "echo $LINK")
  local TARGET=$(cat "$MIGRATION_DIR/target")
  TARGET=$(eval "echo $TARGET")

  create_symlink "$LINK" "$TARGET"
}
