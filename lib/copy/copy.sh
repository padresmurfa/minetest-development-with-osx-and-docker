[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/git" && exit 1

# directory_not_symlink:
#   copies a directory from A to B, replacing B. If A is a symlink, then it's contents will be copied
# usage:
#   copy_directory_not_symlink "<source directory>" "<target directory>"
function copy_directory_not_symlink() {
  local SOURCE="$1"
  local DESTINATION="$2"
  if [[ -L "$DESTINATION" ]]; then
    unlink "$DESTINATION"
  elif [[ -d "$DESTINATION" ]]; then
    rm -rf "$DESTINATION"
  fi
  cp -RL "$SOURCE" "$DESTINATION"
}
