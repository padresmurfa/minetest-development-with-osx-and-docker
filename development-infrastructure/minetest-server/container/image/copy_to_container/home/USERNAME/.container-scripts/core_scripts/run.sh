#!/bin/bash

# see e.g. https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425 for details
set -e
set -u
set -o pipefail

############################################################################################
# DEPLOY
############################################################################################

GAMEID=$1

if [[ ! -d "$HOME/servers/$GAMEID" ]]; then
  >&2 echo "A minetest server deployment was not found at '$HOME/servers/$GAMEID'"
  exit 1
fi

pushd "$HOME/servers/$GAMEID" >> /dev/null

./bin/minetestserver --gameid "$GAMEID"

popd >> /dev/null


