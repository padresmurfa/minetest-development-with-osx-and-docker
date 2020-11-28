[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/ssh" && exit 1

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/user/user.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/migrations/migrations.sh"

# create_migration_install_authorized_key
#   creates a migration that will install an authorized key for the current user, creating one if necessary, with
#   a keyfile identifier of the caller's choice being part of its name (must be valid filename)
# usage:
#   ssh_create_migration_install_authorized_key "remote user name" "key file identifier"
function ssh_create_migration_install_authorized_key() {
  local REMOTE_USERNAME=$1
  local KEYFILEID=$2
  local KEYFILE="$HOME/.ssh/id_rsa_$KEYFILEID"
  local MIGRATION_DIR=$(migrations_create_next_migration "ssh_apply_migration_install_authorized_key" "$REMOTE_USERNAME")
  if [[ ! -f "$KEYFILE.pub" ]]; then
    ssh-keygen -t rsa -f "$KEYFILE" -q -N ""
  fi
  cp "$KEYFILE.pub" "$MIGRATION_DIR/ssh.pubkey"
}

# apply_migration:
#   applies a migration
# usage:
#   bash_apply_migration <migration_dir>
function ssh_apply_migration_install_authorized_key() {
  local MIGRATION_DIR="$1"
  local USERNAME=$("$MIGRATION_DIR/ssh.username")
  local HOMEDIR=$(user_home_of_specific_user "$USERNAME")
  if [[ ! -d "$HOMEDIR/.ssh" ]]; then
    mkdir -p "$HOMEDIR/.ssh"
  fi
  local PUBKEY=$(cat "$MIGRATION_DIR/ssh.pubkey")
  if ! grep -q "$PUBKEY" "$HOMEDIR/.ssh/authorized_keys"; then
    echo "$PUBKEY" >> "$HOMEDIR/.ssh/authorized_keys"
  fi
}
