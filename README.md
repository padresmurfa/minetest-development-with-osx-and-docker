# About

An OSX development environment for Minetest that is run in a Docker container, isolated from the host machine.

## Setup

1. install `Docker Desktop` for Mac
2. clone this repo via `git@github.com:padresmurfa/minetest-development-with-osx-and-docker.git`
3. create the docker image by running `./docker_management/create_docker_image` 
4. start the docker container by running `./docker_management/start_docker_container`

You should now have a running docker container, within a virtual machine that is running on your Mac
    
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

## Setting up Travis CI

1. fork the following repos on git to your own github account:
  * this repository 
  * minetest/minetest
  * minetest/minetest_game
2. Go to `https://travisci.org`, select your profile picture, choose `Settings`
  * Now choose Repositories, activate the `GitHub Apps integration`, and give it access to your copy of the
    aforementioned repositories
3. Go to `Github`, select your profile picture, choose `Settings`
4. Select Personal access tokens, and create a new token for `Travis CI for Minetest`
  * Likely you can entrust Travis CI with most of your non-org capabilities. Feel free to experiment with giving
    Travis a more restrictively authorized token if you would like to.
5. Go to Travis CI, find your copy of this repository, and configure the following environment variables:
  * GITHUB_OAUTH_TOKEN: should contain the value of the Github PAT that you created, above.
  * GITHUB_USERNAME: should contain your Github username
  * GITHUB_USEREMAIL: should contain your Github email address
6. trigger an initial build manually

## Building the Client

