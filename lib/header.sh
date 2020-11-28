[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" == "IMPORTED" ]] && return

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail

readonly LIBRARY_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function dump_stack(){
  # https://stackoverflow.com/questions/685435/trace-of-executed-programs-called-by-a-bash-script
    local i=0
    local line_no
    local function_name
    local file_name
    while caller $i ;do ((i++)) ;done | while read line_no function_name file_name;do echo -e "\t$file_name:$line_no\t$function_name" ;done >&2
}

ROOT_PID=$$
function exit_with_message() {
  >&2 echo $1
  kill -SIGUSR1 "$ROOT_PID"
  exit 1
}

ROOT_PID=$$
function abort() {
  >&2 echo "Aborting the process, message: \"$1\""
  dump_stack
  kill -SIGUSR1 "$ROOT_PID"
  exit 1
}
trap "echo Exiting because my child killed me.>&2;exit 1" SIGUSR1

# abspath:
#   Returns the absolute filename for the provided relative filename
# usage:
#   ABS=$(abspath "<relative path>")
function abspath() {
  local RELATIVE_PATH=$1
  local DIRNAME
  DIRNAME=$(dirname "$RELATIVE_PATH")
  if [[ ! -d "$DIRNAME"  ]]; then
    abort "abspath must not be called for a non-existent path ($DIRNAME)"
  fi
  local BASENAME
  BASENAME=$(basename "$RELATIVE_PATH")
  if [[ "$BASENAME" == ".." ]]; then
    pwd
  else
    pushd "$DIRNAME" >> /dev/null
    ABSOLUTE_DIRNAME=$(pwd)
    popd >> /dev/null
    echo "$ABSOLUTE_DIRNAME/$BASENAME"
  fi
}

readonly PADRESMURFAS_SMURFY_BASH_LIBRARY="IMPORTED"
