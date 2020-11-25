# About

An OSX development environment for Minetest that is run in a Docker container, isolated from the host machine.

## Setup

### Server

1. install `Docker Desktop` for Mac
2. clone this repo via `git@github.com:padresmurfa/minetest-development-with-osx-and-docker.git`
3. create the docker image by running `./docker_management/create_docker_image` 
4. start the docker container by running `./docker_management/start_docker_container`

You should now have a running docker container, within a virtual machine that is running on your Mac
    
### Client

1. run `./mac_management/setup_mac_management` to prepare for the following steps
2. run `./mac_management/create_macosx_virtualmachine` to install the client/build virtual machine.
    * be patient and follow the instructions
    * create a sensible user account when prompted to do so
    * do not bother with an apple-id at this point in time
3. further configure the virtual machine in VirtualBox as such:
    * Display > Remote Display
      * select `Enable Server`
    * Network > Adapter 1
      * select `Attached To > Bridged Adapter`
    * Shared Folders
      * add a new shared folder, pointing towards the `./shared_with_macos_virtual_machine` folder.
        * give this the folder name `shared_with_host`
        * select `Auto-mount`
        * select `/Users/<user-name>/shared_with_host` as the mount point
    * Restart the VM gracefully to make sure the network settings are applied 
4. Install `Microsoft Remote Desktop` from the `App Store` (on your host machine)
  * Add a PC (don't fret about it)
  * Configure it as such:
    * PC name: `localhost`
    * User account: select `Add account` and fill in your account details, and save them
      * this is a convenience, not a requirement
    * General > Friendly name: `minetest-macos-vm`
    * Display
      * Resolution `1440 x 900`
      * enable `Start session in full screen` and `Fit session to window`
5. From within the Mac VM

  * LIKELY THIS HAS NO IMPACT

  * Install `VirtualBox Guest Additions`
    * Select `insert guest additions CD` in the mac vm
    * Open the cd in Finder
    * copy the VBoxDarwinAdditions.pkg file to the desktop
      * this step might not be necessary
    * open VBoxDarwinAdditions, and click through.
      * if you get `Security blocked this...` popup
        * go into security settings and allow the action
        * you may have install the additions again (I haven't verified this)
  * Disable all System Preferences > Energy Saver options
    * to avoid the possibility that the guest may hang, as per: https://www.virtualbox.org/manual/ch14.html
  * shut down the system gracefully
  * restart 
6. When starting the VM, choose headless start, and use Remote Desktop to access it. Otherwise the performance will
   be sad.
   
* Open `System Preferences > Sharing`
  * Enable `Remote Login` for all users
  * Configure the machine name to be `mac-build-machine`
* Open `System Preferences > Desktop & screensaver`
  * Select `Never` as when the screensaver should activate
* install XCode
* install brew
* update rsync
  
  


## Use

1. open a shell in the container via running `./docker_management/login_to_docker_container`
    * you are now located in a bash shell in the docker container
2. to build minetest, run `./copied_from_container/build`

You have now built Minetest, and are ready to start coding or playing

## Edit Code

1. install `IntelliJ IDEA` for Mac
2. open the IntelliJ project found at `source/minetest`
    * this folder is shared with your docker container, thus anything you change will
    be immediately available in the container
3. when you change code, build it in the docker container, not in the host

## Building the Client

