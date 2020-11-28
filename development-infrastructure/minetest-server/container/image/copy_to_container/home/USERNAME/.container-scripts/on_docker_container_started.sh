#!/bin/bash

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail
# determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

############################################################################################
# SERVICES
#   start services, e.g./i.e. rsyslog
############################################################################################

sudo service rsyslog start

############################################################################################
# CORE SCRIPTS
############################################################################################

cp --force --symbolic-link "$SCRIPT_DIR/core_scripts/build.sh" "$HOME/build"
cp --force --symbolic-link "$SCRIPT_DIR/core_scripts/clean.sh" "$HOME/clean"
cp --force --symbolic-link "$SCRIPT_DIR/core_scripts/sync.sh" "$HOME/sync"
cp --force --symbolic-link "$SCRIPT_DIR/core_scripts/deploy.sh" "$HOME/deploy"
cp --force --symbolic-link "$SCRIPT_DIR/core_scripts/run.sh" "$HOME/run"
