[[ "${DEVELOPMENT_ENVIRONMENT_ROOT_HEADER:-NOT_IMPORTED}" == "IMPORTED" ]] && return

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail

readonly ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1090
source "$ROOT_DIRECTORY/lib/header.sh"

readonly DEVELOPMENT_ENVIRONMENT_ROOT_HEADER="IMPORTED"
