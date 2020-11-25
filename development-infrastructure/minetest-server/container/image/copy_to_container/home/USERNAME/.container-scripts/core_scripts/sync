#!/bin/bash

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail

############################################################################################
# SYNC FILES TO BUILD
############################################################################################

function list_uninteresting_files() {
    local DIR=$1
    pushd "$DIR" >> /dev/null
    git clean -dXn \
      | sed "s/Would remove //g" \
      | while read line; do \
        echo "$DIR/$line"; \
      done
    popd >> /dev/null
}

RSYNC_EXCLUDE=$(mktemp)

list_uninteresting_files "$HOME/.shared_from_host/games/minetest_game" >> "$RSYNC_EXCLUDE"
list_uninteresting_files "$HOME/.shared_from_host/minetest" >> "$RSYNC_EXCLUDE"

echo "Synchronizing files from '.shared_from_host' to 'source'"
time rsync --archive --safe-links --executability --acls --xattrs --whole-file \
      --ignore-times --exclude-from="$RSYNC_EXCLUDE" \
      --human-readable \
      "$HOME/.shared_from_host/" "$HOME/source/"
echo ""
echo "Done"

rm "$RSYNC_EXCLUDE"

