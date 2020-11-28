# Tech Debt

## Design debt

* Add locking. If a build is running when a new sync occurs, then the build should be
  cancelled. Likewise if a server is running when a deployment occurs.

* Rather than assuming that the system is for mac-hosts and a single mac-vm-guest + 
1 docker-container-guest, the solution should assume that there may be any host operating
system, and 1 or more guest virtual machines and guest docker containers. The only limitation
being that you can only create a mac-vm-guest if you have a mac-host.

* We should have something akin to a real init system in the docker container, as per:
https://medium.com/@BeNitinAgarwal/an-init-system-inside-the-docker-container-3821ee233f4b

* There is a travis file with a lua checker in the minetest game. We should run it.

* We should use a config file, rather than hardcoded names and sniping the user's local
  login name via whoami.

* we should not use file-system shares from dev-hosts to build-hosts. This pattern requires different
  tooling for each host, and does not work over the internet, thus we cannot e.g. have a remote mac
  build machine or linux server.

* we should apply changes to machines via a migration pattern

## Minor

* When mounting the source directory into the minetest server container as read-only, it
  would be natural to expect that the attributes that the container sees for files in
  the directory do not have write permissions, but this doesn't seem to be the case.

* revise the funky directory/name thingy in deploy for minetest_game. That's just some git repo name issue.

* only one minetest server should be running at any given time, as we only expose one port

* funky ../../.. type imports and execs

* make assert function in header.sh

* docker run is not libbified, and likewise build
