#!/bin/bash

# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/header.sh"
# shellcheck disable=SC1090
source "$LIBRARY_DIRECTORY/service/service.sh"

############################################################################################
# SERVICES
#   start services, e.g./i.e. rsyslog
############################################################################################

service_start rsyslog
service_start ssh
