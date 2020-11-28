[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/user" && exit 1

# usernaame:
#   determines the usernaame of the current user
# usage:
#   USERNAME=$(user_username)
function user_username() {
  whoami
}
