# About

An OSX development environment for Minetest that is run in a Docker container, isolated from the host machine.

## Setup

### Server

1. install `Docker Desktop` for Mac
2. clone this repo via `git@github.com:padresmurfa/minetest-development-with-osx-and-docker.git`
3. create the docker image by running `./development-infrastructure/minetest-server/image/create` 
4. create the docker volumes by running:
  * `./development-infrastructure/minetest-server/volume/create minetest-source` 
  * `./development-infrastructure/minetest-server/volume/create minetest-servers`
5. create the docker image by running `./development-infrastructure/minetest-server/image/create` 
6. start the docker container by running `./development-infrastructure/minetest-server/start`

You should now have a running docker container, within a virtual machine that is running in VirtualBox, on your Mac
    
### Client

1. run `./development-infrastructure/minetest-mac-build-machine/create` to install the client/build virtual machine.
    * be patient and follow the instructions
    * create a user account when prompted to do so
      * **IMPORTANT: use the same username as in the host machine**, the various scripts
      * in this solution depend on it
    * From within `🍎 > System Preferences`
      * Open `Sharing`
        * Enable `Remote Login`
        * Allow access for `All users
        * Configure the machine name to be `minetest-mac-build-machine`
    * Shutdown the virtual machine gracefully from the `🍎` menu.
      * be patient, let the shutdown scripts run, and do not power off the VM

2. further configure the virtual machine in the VirtualBox UI as such:
    * Network > Adapter 1
      * select `Attached To > Bridged Adapter`

3. Perform post-installation configuration via
    * Running the `setup` script found in `minetest-mac-build-machine/host_scripts`

4. Install `Microsoft Remote Desktop` from the `App Store` (on your host machine)
  * Add a PC (don't fret about it)
  * Configure it as such:
    * PC name: `localhost`
    * User account: select `Add account` and fill in your login details to the VM. Save them
      * this is a convenience, not a requirement
    * General > Friendly name: `minetest-mac-build-machine`
    * Display
      * Resolution `1440 x 900`
      * enable `Start session in full screen` and `Fit session to window`
      
### Using to the virtual Mac build machine

Henceforth you should avoid launching the VM in `normal` mode, opting instead for starting the VM
in `headless` mode, e.g.

  * by running the `start` script found in `minetest-mac-build-machine/host_scripts`
  * or by selecting `start` / `headless` in the VirtualBox client

and subsequently interacting with it via:

  * running the `shell` script found in `minetest-mac-build-machine/host_scripts`
  * interacting with it directly via `ssh`
    * e.g. `ssh <username>@minetest-mac-build-machine`
  * interacting with it via `Microsoft Remote Desktop`
    * e.g. by right-clicking the machine in the remote-desktop client, and selecting `connect`

These methods significantly outperforms a normal desktop session started via the VirtualBox client.

## Configure the Mac VM for builds
  
5. Configure the Mac VM further:
  * install / update:
    * XCode via the `App Store`
    * or via `developer.apple.com/downloads`
  
## Using the server

1. open a shell in the container via running `./development-infrastructure/minetest-server/shell`
    * you are now located in a bash shell in the docker container
2. to build minetest in the docker container, run `./build`

You have now built Minetest, and are ready to start coding or playing

## Editing Code

1. install `IntelliJ IDEA` for Mac
2. open the IntelliJ project found at `source/minetest`
    * this folder is shared with your docker container, thus anything you change will
    be immediately available in the container, but it will not be synced and built until
    you run `./sync` and `./build`, respectively.
3. to re-iterate: when you change code, build it in the docker container, not in the host

## Building the Client

TBD

