[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/synchronizer" && exit 1

# init:
#   initializes the synchronizer
# usage:
#   synchronizer_init "<SOURCE>" "<DESTINATION>"
function synchronizer_init() {
  SYNCHRONIZER_SOURCE_DIRECTORY="$(abspath "$1")/"
  if [[ ! -d "$2" ]]; then
    mkdir -p "$2"
  fi
  SYNCHRONIZER_DESTINATION_DIRECTORY="$(abspath "$2")/"
  SYNCHRONIZER_EXCLUDE_FROM_FILE="$(mktemp)"
  touch "$SYNCHRONIZER_EXCLUDE_FROM_FILE"
}

# serialize_config
#   serializes the config required to instantiate a synchronizer
# usage:
#   synchronizer_serialize_config > $SERIALIZED_CONFIG
function synchronizer_serialize_config() {
  echo "SYNCHRONIZER_SOURCE_DIRECTORY=${SYNCHRONIZER_SOURCE_DIRECTORY#"$ROOT_DIRECTORY/"}" | sed 's/.$//'
  echo "SYNCHRONIZER_DESTINATION_DIRECTORY=${SYNCHRONIZER_DESTINATION_DIRECTORY#"$ROOT_DIRECTORY/"}" | sed 's/.$//'
}

# deserialize
#   deserializes the config required to instantiate a synchronizer, initializing the library
# usage:
#   synchronizer_deserialize_config $SERIALIZED_CONFIG
function synchronizer_deserialize_config() {
  local SERIALIZED_CONFIG=$1
  # shellcheck disable=SC1090
  source "$SERIALIZED_CONFIG"
  synchronizer_init "$SYNCHRONIZER_SOURCE_DIRECTORY" "$SYNCHRONIZER_DESTINATION_DIRECTORY"
}

# teardown
#   tears down the synchronizer, releasing system resources
# usage:
#   synchronizer_teardown
function synchronizer_teardown() {
  rm "$SYNCHRONIZER_EXCLUDE_FROM_FILE"
}

# exclude_git_ignored_files_from_subfolder:
#   Member function that excludes all git-ignored files from a specific subfolder of our source directory
# usage:
#   synchronizer_exclude_git_ignored_files_from_subfolder <subfolder name>
function synchronizer_exclude_git_ignored_files_from_subfolder() {
  local SUBFOLDER="$SYNCHRONIZER_SOURCE_DIRECTORY/$1"

  pushd "$SUBFOLDER" >> /dev/null || exit 1
  
    # -d: recurse into un-tracked directories
    # -X: remove only files that are ignored by git. I.e. keep manually created files
    # -n: don't actually remove anything, just show what would be done
    git clean -dXn | sed "s/Would remove //g" | while read -r FILE_OR_FOLDER; do
      echo "$SUBFOLDER/$FILE_OR_FOLDER" >> "$SYNCHRONIZER_EXCLUDE_FROM_FILE"
    done

  popd >> /dev/null || exit 1
}

# exclude_git_ignored_files_from_subfolder:
#   Member function that excludes all git-ignored files from a specific subfolder of our source directory
# usage:
#   synchronizer_exclude_git_ignored_files_from_subfolder <subfolder name>
function synchronizer_exclude_git_ignored_files_from_subfolder() {
  local SUBFOLDER="$SYNCHRONIZER_SOURCE_DIRECTORY/$1"

  pushd "$SUBFOLDER" >> /dev/null || exit 1

    # -d: recurse into un-tracked directories
    # -X: remove only files that are ignored by git. I.e. keep manually created files
    # -n: don't actually remove anything, just show what would be done
    git clean -dXn | sed "s/Would remove //g" | while read -r FILE_OR_FOLDER; do
      echo "$SUBFOLDER/$FILE_OR_FOLDER" >> "$SYNCHRONIZER_EXCLUDE_FROM_FILE"
    done

  popd >> /dev/null || exit 1
}

# synchronize:
#   Synchronizes files from our source directory to our destination directory, excluding any files
#   that should be excluded as per previous calls to exclude_git_ignored_files_from_subfolder.
# usage:
#   synchronizer_synchronize
function synchronizer_synchronize() {
  rsync --archive --safe-links --executability --acls --xattrs --whole-file \
        --checksum --exclude-from="$SYNCHRONIZER_EXCLUDE_FROM_FILE" \
        --human-readable --mkpath --delete \
        "$SYNCHRONIZER_SOURCE_DIRECTORY" "$SYNCHRONIZER_DESTINATION_DIRECTORY"
}

# dry_run:
#   returns a list of files that would have been transferred
# usage:
#   synchronizer_dry_run > $OUTPUT_TO
function synchronizer_dry_run() {
  rsync --dry-run \
        --archive --safe-links --executability --acls --xattrs --whole-file \
        --checksum --exclude-from="$SYNCHRONIZER_EXCLUDE_FROM_FILE" \
        --mkpath --delete \
        --out-format="%o:%f" \
        "$SYNCHRONIZER_SOURCE_DIRECTORY" "$SYNCHRONIZER_DESTINATION_DIRECTORY"
}

# create_migration:
#   creates a migration based on this synchronizer's state
# usage:
#   synchronizer_create_migratio
function synchronizer_create_migration() {
  local MIGRATION_DIR=$(migrations_create_next_migration "synchronizer_apply_migration" "")
  synchronizer_serialize_config > "$MIGRATION_DIR/synchronizer.config.serialized"
  synchronizer_dry_run | while read -r ACTION; do
    if [[ "$ACTION" =~ ^send: ]]; then
      local TRUNCATE="send:${SYNCHRONIZER_SOURCE_DIRECTORY:1}"
      local TRUNCATED="${ACTION#$TRUNCATE}"
      local TRANSFORMED="${TRUNCATED//./\\./}"
      echo "^$TRANSFORMED\$" >> "$MIGRATION_DIR/synchronizer.changes.rsync"
    elif [[ "$ACTION" =~ ^del\.: ]]; then
      local TRUNCATE="del.:"
      local TRUNCATED="${ACTION#$TRUNCATE}"
      local TRANSFORMED="${TRUNCATED//./\\./}"
      echo "$TRANSFORMED" >> "$MIGRATION_DIR/synchronizer.changes.delete"
    fi
  done
}

# apply_migration:
#   applies a migration
# usage:
#   synchronizer_apply_migration <migration_dir>
function synchronizer_apply_migration() {
  local MIGRATION_DIR="$1"
  synchronizer_deserialize_config "$MIGRATION_DIR/synchronizer.config.serialized"
  if [[ -f "$MIGRATION_DIR/synchronizer.changes.rsync" ]]; then
    rsync --archive --safe-links --executability --acls --xattrs --whole-file \
          --checksum --include-from="$MIGRATION_DIR/synchronizer.changes.rsync" \
          --mkpath \
          "$SYNCHRONIZER_SOURCE_DIRECTORY" "$SYNCHRONIZER_DESTINATION_DIRECTORY"
  fi
  if [[ -f "$MIGRATION_DIR/synchronizer.changes.delete" ]]; then
    # read relative paths from "$MIGRATION_DIR/synchronizer.config.del", line by line
    while read -r RELATIVE_PATH; do
      local FULL_PATH="$SYNCHRONIZER_DESTINATION_DIRECTORY/$RELATIVE_PATH"
      if [[ -f "$FULL_PATH" ]]; then
        rm -f "$FULL_PATH"
      fi
    done < "$MIGRATION_DIR/synchronizer.changes.delete"
  fi
}
