[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/git" && exit 1

# ignore:
#   adds a new pattern in a .gitignore file (i.e. only if the pattern isn't in it already)
# usage:
#   git_ignore "<file>" "<folder containing .gitignore file>"
function git_ignore() {
  local GITIGNORE_FILENAME="$1/.gitignore"
  local PATTERN=$2
  if [[ -z grep -q "$PATTERN" "$GITIGNORE_FILENAME" ]]; then
    echo "$PATTERN" >> "$GITIGNORE_FILENAME"
  fi
}
