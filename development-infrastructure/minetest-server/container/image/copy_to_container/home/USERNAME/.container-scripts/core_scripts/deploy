#!/bin/bash

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail

############################################################################################
# DEPLOY
############################################################################################

GAME_DIRECTORY=$1
GAMEID=$2

if [[ ! -d "$HOME/source/games/$GAME_DIRECTORY" ]]; then
  >&2 echo "The game '$GAMEID' was not found at '$HOME/source/games/$GAME_DIRECTORY'"
  exit 1
fi

if [[ ! -x "$HOME/source/minetest/bin/minetestserver" ]]; then
  >&2 echo "The server binary was not found at '$HOME/source/minetest/bin/minetestserver'. Please build it first."
  exit 1
fi

if [[ ! -d "$HOME/servers/$GAMEID" ]]; then
  mkdir -p "$HOME/servers/$GAMEID"
  mkdir "$HOME/servers/$GAMEID/games"
  mkdir "$HOME/servers/$GAMEID/bin"
  mkdir "$HOME/servers/$GAMEID/builtin"
fi

function copy() {
    local SOURCE=$1
    local DESTINATION=$2
    rsync --archive --safe-links --executability --acls --xattrs --whole-file \
      --ignore-times --human-readable \
      "$SOURCE" "$DESTINATION"
}

echo "Copying server binary ..."
copy "$HOME/source/minetest/bin/minetestserver" "$HOME/servers/$GAMEID/bin/minetestserver"
echo "Copying server builtins ..."
copy "$HOME/source/minetest/builtin/" "$HOME/servers/$GAMEID/builtin/"
echo "Copying game files from '~/source/games/$GAME_DIRECTORY' to '~/servers/$GAMEID/games/$GAMEID' ..."
copy "$HOME/source/games/$GAME_DIRECTORY/" "$HOME/servers/$GAMEID/games/$GAMEID"
echo ""
echo "Done."

