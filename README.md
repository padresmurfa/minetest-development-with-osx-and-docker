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

You should now have a running docker container, within a virtual machine that is running on your Mac
    
### Client

use dmidecode to help determine the correct values for the config in `macos_vm_vars.conf`
(http://cavaliercoder.com/blog/dmidecode-for-apple-osx.html)

activation issue:
https://simplemdm.com/apple-dep-vmware-parallels-virtualbox/

fetch older versions of xcode:
developer.apple.com/downloads

1. run `./development-infrastructure/minetest-mac-build-machine/create` to install the client/build virtual machine.
    * be patient and follow the instructions
    * create a sensible user account when prompted to do so
2. further configure the virtual machine in VirtualBox as such:
    * Display > Remote Display
      * select `Enable Server`
    * Network > Adapter 1
      * select `Attached To > Bridged Adapter`
    * Restart the VM gracefully to make sure the network settings are applied 
4. Install `Microsoft Remote Desktop` from the `App Store` (on your host machine)
  * Add a PC (don't fret about it)
  * Configure it as such:
    * PC name: `localhost`
    * User account: select `Add account` and fill in your account details, and save them
      * this is a convenience, not a requirement
    * General > Friendly name: `minetest-mac-build-machine`
    * Display
      * Resolution `1440 x 900`
      * enable `Start session in full screen` and `Fit session to window`
5. From within the Mac VM
  * in `🍎 > System Preferences`
  * Disable all Energy Saver options
    * to avoid the possibility that the guest may hang, as per: https://www.virtualbox.org/manual/ch14.html
  * Open `Sharing`
    * Enable `Remote Login` for all users
    * Configure the machine name to be `mac-build-machine`
  * Open `Desktop & Screen Saver`
    * Select `Never` as when the screensaver should activate
  * install / update:
    * XCode via the App Store
    * homebrew
      * e.g. see https://bayton.org/2018/07/how-to-update-rsync-on-mac-os-high-sierra/
        and https://docs.brew.sh/Installation
    * update rsync via brew
  * shut down the system gracefully
  * restart 

6. When starting the VM, choose headless start, and use Remote Desktop to access it. Otherwise the performance will
   be sad.
   
## Use

1. open a shell in the container via running `./development-infrastructure/minetest-server/shell`
    * you are now located in a bash shell in the docker container
2. to build minetest in the docker container, run `./build`

You have now built Minetest, and are ready to start coding or playing

## Edit Code

1. install `IntelliJ IDEA` for Mac
2. open the IntelliJ project found at `source/minetest`
    * this folder is shared with your docker container, thus anything you change will
    be immediately available in the container, but it will not be synced and built until
    you run `./sync` and `./build`, respectively.
3. to re-iterate: when you change code, build it in the docker container, not in the host

## Building the Client

