# Synchronizer

Synchronize files between one or more git-repos and a destination, via rsync

## Example

```
source "<project root>/lib/header.sh"
source "$LIBRARY_DIRECTORY/synchronizer/synchronizer.sh"

synchronizer_init "$ROOT_DIRECTORY/source" "$ROOT_DIRECTORY/.destination"
synchronizer_exclude_git_ignored_files_from_subfolder "minetest"
synchronizer_exclude_git_ignored_files_from_subfolder "games/minetest_game"
synchronizer_synchronize
synchronizer_teardown
```
