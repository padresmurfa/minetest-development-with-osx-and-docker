FROM --platform=linux/amd64 ubuntu:16.04

# the maintainer of this file is David Brandt, aka Padre Smurfa
LABEL maintainer="padresmurfa@gmail.com"

############################################################################################
# HOME
#   user home directories should not be accessible to other users by default.
#   not important really, just a principle
RUN sed -i 's/DIR_MODE=0755/DIR_MODE=0750/g' /etc/adduser.conf

############################################################################################
# APT
#   we would like apt to be up-to-date at the time
#   of creating the container, and to install a number of basic tools, system tools,
#   developer tools, and build tools
############################################################################################

RUN apt-get update \
 && apt-get install --assume-yes \
    rsyslog sudo \
    curl less wget zip unzip vim \
    git \
    g++ make libc6-dev libirrlicht-dev cmake libbz2-dev libpng-dev libjpeg-dev \
      libxxf86vm-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev libopenal-dev \
      libcurl4-gnutls-dev libfreetype6-dev zlib1g-dev libgmp-dev libjsoncpp-dev

############################################################################################
# SYSLOG
#   we would like to have syslog functioning properly,
#   and would like our logs to be clean of errors
#   from the get-go, thus we disable the kernel log
############################################################################################

RUN sed --in-place '/imklog/s/^/#/' /etc/rsyslog.conf \
 && service rsyslog start

############################################################################################
# ROOT
#   root would like to use /bin/bash as the default shell, and to be present in /home/root
#   for the sake of consistency. Also, fix up the ugly bash prompt. We're not interested
#   in having the container hash in there.
############################################################################################

RUN chsh --shell /bin/bash \
 && cd /home && ln -s /root root \
 && sed --in-place 's/@\\h/@minetest/g' /etc/bash.bashrc \
 && cp /etc/bash.bashrc /root/.bashrc \
 && cp /etc/bash.bashrc /etc/skel/.bashrc \
 && chown root:root /root/.bashrc \
 && chmod 0750 /root/.bashrc

############################################################################################
# USER
#  we do not wish to run everything as root, thus we create a user for our purposes. Some
#  interesting properties of this user:
#  ... has the same username, uid and gid as the user that runs this script
#  ... is a sudoer, and thus does will not be prompted for a password when calling sudo
#  ... has a home directory at /home/<username>
#  ... has /bin/bash as the default shell
############################################################################################

ARG USERNAME
ARG UID
RUN addgroup $USERNAME \
 && adduser --shell /bin/bash --uid $UID --ingroup $USERNAME $USERNAME \
 && usermod -aG sudo $USERNAME \
 && echo "$USERNAME     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME

############################################################################################
# SCRIPTS
#   install a few scripts to get things started
############################################################################################

COPY --chown=$UID:$GID copy_to_container/ /home/$USERNAME/copied_from_host/

############################################################################################
# INITIAL STATE
############################################################################################

# the initial directory will always be the user's home
# directory
WORKDIR /home/$USERNAME

# Note that some actions taken in this Dockerfile, such as starting the rsyslogd service,
# are not persistent and thus need to be performed upon launch, akin to as if they were
# registered in init.d.
# To facilitate that, any necessary start-up actions for the container that are not part of
# the docker image will be orchestrated from .start_docker_container.
ENTRYPOINT ["/bin/bash", "-ci", "./copied_from_host/.start_docker_container"]
