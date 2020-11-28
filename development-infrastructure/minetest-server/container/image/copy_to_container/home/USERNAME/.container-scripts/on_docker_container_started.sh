#!/bin/bash

# Determine the directory this script resides in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/lib/header.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/service/service.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/migrations/migrations.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/bash/bash.sh"

# make lib available to migrations LIBRARY_DIRECTORY
export LIBRARY_DIRECTORY
CONTAINER_SCRIPTS="$SCRIPT_DIR"
export CONTAINER_SCRIPTS

migrations_init "$SCRIPT_DIR/static_migrations"
migrations_apply
migrations_teardown

migrations_init "$SCRIPT_DIR/dynamic_migrations"
migrations_apply
migrations_teardown
