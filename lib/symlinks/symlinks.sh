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
