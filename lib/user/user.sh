[[ "${PADRESMURFAS_SMURFY_BASH_LIBRARY:-NOT_IMPORTED}" != "IMPORTED" ]] \
  && echo "Please import lib/header.sh before importing lib/user" && exit 1

# username:
#   determines the usernaame of the current user
# usage:
#   USERNAME=$(user_username)
function user_username() {
  whoami
}

# home_of_specific_user:
#   determines the home directory of a specific user
# usage:
#   HOME_DIR=$(user_home_of_specific_user)
function user_home_of_specific_user() {
  local USER=$1
  awk -v FS=':' -v user="$USER" '($1==user) {print $6}' "/etc/passwd"
}
